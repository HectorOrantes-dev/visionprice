import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/register_result_entity.dart';
import '../../domain/entities/role_entity.dart';

/// Fuente de datos remota: habla HTTP con el back-end. Es lo único que conoce
/// rutas y forma del JSON. Se expone por interfaz para poder sustituirla
/// (mock/fake) en tests. Mapea el JSON directamente a entidades de dominio
/// con sus `fromJson` (sin DTOs intermedios).
abstract class AuthRemoteDataSource {
  Future<void> login(String correo, String contrasena);
  Future<AuthSessionEntity> verifyTwoFactor(String correo, String code);
  Future<List<RoleEntity>> getRoles();
  Future<RegisterResultEntity> register(Map<String, dynamic> body);
  Future<AuthSessionEntity> googleLogin(String idToken);
  Future<AuthSessionEntity> googleRegister(String idToken, String rol);
}

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
}
