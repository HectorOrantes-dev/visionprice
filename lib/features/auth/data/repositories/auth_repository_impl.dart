import 'package:injectable/injectable.dart';

import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/register_result_entity.dart';
import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementación del contrato de dominio. Orquesta el datasource remoto y la
/// persistencia local del token. Registrada como la interfaz `AuthRepository`.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._remote, this._tokenStorage);

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
    await _tokenStorage.saveToken(session.accessToken);
    return session;
  }

  @override
  Future<AuthSessionEntity> googleRegister({
    required String idToken,
    required String rol,
  }) async {
    final session = await _remote.googleRegister(idToken, rol);
    await _tokenStorage.saveToken(session.accessToken);
    return session;
  }

  @override
  Future<void> logout() => _tokenStorage.clear();
}
