import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/entities/register_result_entity.dart';
import '../../domain/entities/role_entity.dart';
import 'auth_remote_datasource.dart';

/// `@LazySingleton(as: AuthRemoteDataSource)`: Injectable registra esta
/// implementación bajo el tipo de la interfaz. Los consumidores piden
/// `AuthRemoteDataSource` y reciben esta clase.
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _client;
  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<void> login(String correo, String contrasena) async {
    await _client.postJson(ApiConfig.login, {
      'correo': correo,
      'contrasena': contrasena,
    });
  }

  @override
  Future<AuthSessionEntity> verifyTwoFactor(String correo, String code) async {
    final data = await _client.postJson(ApiConfig.loginVerify, {
      'correo': correo,
      'code': code,
    });
    return AuthSessionEntity.fromJson(data);
  }

  @override
  Future<List<RoleEntity>> getRoles() async {
    final data = await _client.getJsonList(ApiConfig.roles);
    return data.map(RoleEntity.fromJson).toList();
  }

  @override
  Future<RegisterResultEntity> register(Map<String, dynamic> body) async {
    final data = await _client.postJson(ApiConfig.register, body);
    return RegisterResultEntity.fromJson(data);
  }

  @override
  Future<AuthSessionEntity> googleLogin(String idToken) async {
    final data = await _client.postJson(ApiConfig.googleLogin, {
      'id_token': idToken,
    });
    return AuthSessionEntity.fromJson(data);
  }

  @override
  Future<AuthSessionEntity> googleRegister(String idToken, String rol) async {
    final data = await _client.postJson(ApiConfig.googleRegister, {
      'id_token': idToken,
      'rol': rol,
    });
    return AuthSessionEntity.fromJson(data);
  }

  @override
  Future<void> forgotPassword(String correo) async {
    await _client.postJson(ApiConfig.passwordForgot, {'correo': correo});
  }

  @override
  Future<void> resetPassword(
      String correo, String code, String nuevaContrasena) async {
    await _client.postJson(ApiConfig.passwordReset, {
      'correo': correo,
      'code': code,
      'nueva_contrasena': nuevaContrasena,
    });
  }

  @override
  Future<PerfilEntity> getPerfil() async {
    final data = await _client.getJson(ApiConfig.mePerfil, auth: true);
    return PerfilEntity.fromJson(data);
  }
}
