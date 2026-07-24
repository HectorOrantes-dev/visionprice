import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/storage/local_database.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/entities/register_result_entity.dart';
import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementación del contrato de dominio. Orquesta el datasource remoto y la
/// persistencia local del token. Registrada como la interfaz `AuthRepository`.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;
  final LocalDatabase _localDatabase;

  AuthRepositoryImpl(this._remote, this._tokenStorage, this._localDatabase);

  /// Caché en memoria del perfil. Como este repositorio es `@LazySingleton`,
  /// vive toda la sesión: el perfil se pide UNA vez a la red y luego se
  /// reutiliza (se limpia en [logout]).
  PerfilEntity? _perfilCache;

  @override
  Future<AuthSessionEntity?> login({
    required String correo,
    required String contrasena,
  }) async {
    final session = await _remote.login(correo, contrasena);
    // Login directo (sin 2FA): persiste el token igual que verifyTwoFactor.
    if (session != null) {
      await _limpiarPerfilDeOtraCuenta();
      await _tokenStorage.saveToken(session.accessToken);
    }
    return session;
  }

  @override
  Future<AuthSessionEntity> verifyTwoFactor({
    required String correo,
    required String code,
  }) async {
    final session = await _remote.verifyTwoFactor(correo, code);
    await _limpiarPerfilDeOtraCuenta();
    await _tokenStorage.saveToken(session.accessToken);
    return session;
  }

  @override
  Future<List<RoleEntity>> getRoles() => _remote.getRoles();

  @override
  Future<RegisterResultEntity> register({
    required String nombre,
    required String correo,
    required String contrasena,
    required String rol,
    String? telefono,
  }) {
    return _remote.register({
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
      'rol': rol,
      if (telefono != null && telefono.isNotEmpty) 'telefono': telefono,
    });
  }

  @override
  Future<AuthSessionEntity> googleLogin({required String idToken}) async {
    final session = await _remote.googleLogin(idToken);
    await _limpiarPerfilDeOtraCuenta();
    await _tokenStorage.saveToken(session.accessToken);
    return session;
  }

  @override
  Future<AuthSessionEntity> googleRegister({
    required String idToken,
    required String rol,
  }) async {
    final session = await _remote.googleRegister(idToken, rol);
    await _limpiarPerfilDeOtraCuenta();
    await _tokenStorage.saveToken(session.accessToken);
    return session;
  }

  @override
  Future<void> forgotPassword({required String correo}) =>
      _remote.forgotPassword(correo);

  @override
  Future<String> verifyResetCode({
    required String correo,
    required String code,
  }) =>
      _remote.verifyResetCode(correo, code);

  @override
  Future<AuthSessionEntity?> resetPassword({
    required String correo,
    required String resetToken,
    required String nuevaContrasena,
  }) async {
    final session =
        await _remote.resetPassword(correo, resetToken, nuevaContrasena);
    // Auto-login tras el reset: persiste el token igual que verifyTwoFactor.
    if (session != null) {
      await _limpiarPerfilDeOtraCuenta();
      await _tokenStorage.saveToken(session.accessToken);
    }
    return session;
  }

  @override
  Future<PerfilEntity> getPerfil({bool forceRefresh = false}) async {
    if (!forceRefresh && _perfilCache != null) return _perfilCache!;
    try {
      final perfil = await _remote.getPerfil();
      _perfilCache = perfil;
      // Guardado local best-effort: si el insert falla (tabla, esquema, etc.)
      // NO debe tirar el perfil recién bajado de la red. Se registra y sigue.
      _guardarPerfilLocal(perfil);
      return perfil;
    } catch (e) {
      debugPrint('getPerfil: falló la red ($e). Intentando caché local…');
      // Si falla la red, intentar recuperar de local (best-effort).
      try {
        final db = await _localDatabase.database;
        // Filtra por el usuario actual (el JWT ya identifica quién es): sin
        // esto, si alguna vez quedaran filas de más de una cuenta en esta
        // tabla, se devolvía la primera que SQLite trajera, sin garantía de
        // que fuera la de la sesión activa.
        final maps = await db.query(
          'perfil',
          where: 'id = ?',
          whereArgs: [_tokenStorage.userId],
          limit: 1,
        );
        if (maps.isNotEmpty) {
          final perfil = PerfilEntity.fromJson(maps.first);
          _perfilCache = perfil;
          return perfil;
        }
      } catch (localErr) {
        debugPrint('getPerfil: tampoco hay perfil local ($localErr).');
      }
      rethrow; // sin red ni local → propaga el error original
    }
  }

  @override
  Future<PerfilEntity> actualizarPerfil(
      {String? nombre, String? telefono}) async {
    final perfil =
        await _remote.actualizarPerfil(nombre: nombre, telefono: telefono);
    _perfilCache = perfil;
    _guardarPerfilLocal(perfil);
    return perfil;
  }

  /// Persiste el perfil en SQLite sin bloquear ni fallar el flujo principal.
  /// SQLite solo acepta num/String/blob → el bool `activo` va como 1/0.
  Future<void> _guardarPerfilLocal(PerfilEntity perfil) async {
    try {
      final db = await _localDatabase.database;
      final row = perfil.toJson()..['activo'] = perfil.activo ? 1 : 0;
      await db.insert('perfil', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint('getPerfil: no se pudo guardar el perfil local ($e).');
    }
  }

  /// Borra CUALQUIER rastro de la cuenta anterior en el dispositivo (memoria +
  /// SQLite local) antes de guardar el token de una cuenta nueva.
  ///
  /// Ninguna de estas tablas locales tiene columna de usuario — son cachés
  /// "del dispositivo", no "de la cuenta". Sin esto, cambiar de cuenta (con
  /// o sin `logout()` explícito de por medio) deja varias fugas reales:
  /// - `_perfilCache` en memoria sigue vivo hasta el primer `forceRefresh`.
  /// - `perfil` en SQLite: si la primera `/me/perfil` con el token nuevo
  ///   falla por red, `getPerfil()` cae a este fallback — de la cuenta vieja.
  /// - `proyectos` en SQLite: peor todavía — `ProyectoRepositoryImpl.listar()`
  ///   ni siquiera llama al back-end si la tabla local ya tiene filas, así
  ///   que la cuenta nueva ve los proyectos de la cuenta anterior a secas,
  ///   sin red de por medio.
  /// - `cotizaciones_pdf`: mismo patrón de caché offline por dispositivo.
  Future<void> _limpiarPerfilDeOtraCuenta() async {
    _perfilCache = null;
    try {
      final db = await _localDatabase.database;
      await db.delete('perfil');
      await db.delete('proyectos');
      await db.delete('cotizaciones_pdf');
    } catch (e) {
      debugPrint('_limpiarPerfilDeOtraCuenta: no se pudo borrar local ($e).');
    }
  }

  @override
  Future<void> logout() async {
    await _limpiarPerfilDeOtraCuenta();
    await _tokenStorage.clear();
  }
}
