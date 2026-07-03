import 'package:injectable/injectable.dart';

import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/entities/register_result_entity.dart';
import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/perfil_storage.dart';

/// Implementación del contrato de dominio. Orquesta el datasource remoto y la
/// persistencia local del token. Registrada como la interfaz `AuthRepository`.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;
  final PerfilStorage _perfilStorage;

  AuthRepositoryImpl(this._remote, this._tokenStorage, this._perfilStorage);

  /// Caché en memoria del perfil. Como este repositorio es `@LazySingleton`,
  /// vive toda la sesión; además se respalda en disco ([PerfilStorage]) para
  /// que los datos sobrevivan al reinicio de la app. Se limpia en [logout].
  PerfilEntity? _perfilCache;

  @override
  Future<void> login({
    required String correo,
    required String contrasena,
  }) {
    return _remote.login(correo, contrasena);
  }

  @override
  Future<AuthSessionEntity> verifyTwoFactor({
    required String correo,
    required String code,
  }) async {
    final session = await _remote.verifyTwoFactor(correo, code);
    await _tokenStorage.saveSession(session.accessToken, session.refreshToken);
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
    await _tokenStorage.saveSession(session.accessToken, session.refreshToken);
    return session;
  }

  @override
  Future<AuthSessionEntity> googleRegister({
    required String idToken,
    required String rol,
  }) async {
    final session = await _remote.googleRegister(idToken, rol);
    await _tokenStorage.saveSession(session.accessToken, session.refreshToken);
    return session;
  }

  @override
  Future<void> forgotPassword({required String correo}) =>
      _remote.forgotPassword(correo);

  @override
  Future<void> resetPassword({
    required String correo,
    required String code,
    required String nuevaContrasena,
  }) =>
      _remote.resetPassword(correo, code, nuevaContrasena);

  @override
  Future<PerfilEntity> getPerfil({bool forceRefresh = false}) async {
    // 1) Siembra la caché en memoria desde disco (persistencia entre reinicios).
    _perfilCache ??= _perfilStorage.read();
    // 2) Si ya tenemos datos y no se fuerza recarga, devuélvelos al instante.
    if (!forceRefresh && _perfilCache != null) return _perfilCache!;
    // 3) Pide a la red y respalda en memoria + disco.
    try {
      final perfil = await _remote.getPerfil();
      _perfilCache = perfil;
      await _perfilStorage.save(perfil);
      return perfil;
    } catch (e) {
      // Sin red o error transitorio: conserva lo guardado en vez de romper.
      if (_perfilCache != null) return _perfilCache!;
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    _perfilCache = null;
    await _perfilStorage.clear();
    await _tokenStorage.clear();
  }
}
