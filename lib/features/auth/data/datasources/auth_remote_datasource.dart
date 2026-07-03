import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/entities/register_result_entity.dart';
import '../../domain/entities/role_entity.dart';

/// Fuente de datos remota: habla HTTP con el back-end. Es lo único que conoce
/// rutas y forma del JSON. Se expone por interfaz para poder sustituirla
/// (mock/fake) en tests. Mapea el JSON directamente a entidades de dominio
/// con sus `fromJson` (sin DTOs intermedios).
abstract class AuthRemoteDataSource {
  /// Devuelve la sesión si el back-end responde con `access_token` (login
  /// directo, sin 2FA); `null` si en su lugar envió un código de verificación.
  Future<AuthSessionEntity?> login(String correo, String contrasena);
  Future<AuthSessionEntity> verifyTwoFactor(String correo, String code);
  Future<List<RoleEntity>> getRoles();
  Future<RegisterResultEntity> register(Map<String, dynamic> body);
  Future<AuthSessionEntity> googleLogin(String idToken);
  Future<AuthSessionEntity> googleRegister(String idToken, String rol);
  Future<void> forgotPassword(String correo);

  /// Verifica el código de recuperación. Devuelve el `reset_token` (JWT de un
  /// solo uso) que autoriza el cambio de contraseña.
  Future<String> verifyResetCode(String correo, String code);

  /// Establece la nueva contraseña. El back-end responde con la sesión ya
  /// iniciada (`access_token`) → devuelve `AuthSessionEntity`; `null` si por
  /// algún motivo no vino token.
  Future<AuthSessionEntity?> resetPassword(
      String correo, String resetToken, String nuevaContrasena);
  Future<PerfilEntity> getPerfil();
}

/// `@LazySingleton(as: AuthRemoteDataSource)`: Injectable registra esta
/// implementación bajo el tipo de la interfaz. Los consumidores piden
/// `AuthRemoteDataSource` y reciben esta clase.
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _client;
  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<AuthSessionEntity?> login(String correo, String contrasena) async {
    final data = await _client.postJson(ApiConfig.login, {
      'correo': correo,
      'contrasena': contrasena,
    });
    // Si el back-end ya devuelve token (2FA desactivado), la sesión queda
    // lista; si solo mandó el código de verificación, no hay token → null.
    final token = (data['access_token'] ?? data['token'] ?? '').toString();
    return token.isEmpty ? null : AuthSessionEntity.fromJson(data);
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
  Future<String> verifyResetCode(String correo, String code) async {
    final data = await _client.postJson(ApiConfig.passwordVerifyCode, {
      'correo': correo,
      'code': code,
    });
    return data['reset_token'] as String;
  }

  @override
  Future<AuthSessionEntity?> resetPassword(
      String correo, String resetToken, String nuevaContrasena) async {
    final data = await _client.postJson(ApiConfig.passwordReset, {
      'correo': correo,
      'reset_token': resetToken,
      'nueva_contrasena': nuevaContrasena,
    });
    final token = (data['access_token'] ?? data['token'] ?? '').toString();
    return token.isEmpty ? null : AuthSessionEntity.fromJson(data);
  }

  @override
  Future<PerfilEntity> getPerfil() async {
    final data = await _client.getJson(ApiConfig.mePerfil, auth: true);
    return PerfilEntity.fromJson(data);
  }
}
