import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/entities/register_result_entity.dart';
import '../../domain/entities/role_entity.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionEntity?> login(String correo, String contrasena);
  Future<AuthSessionEntity> verifyTwoFactor(String correo, String code);
  Future<List<RoleEntity>> getRoles();
  Future<RegisterResultEntity> register(Map<String, dynamic> body);
  Future<AuthSessionEntity> googleLogin(String idToken);
  Future<AuthSessionEntity> googleRegister(String idToken, String rol);
  Future<void> forgotPassword(String correo);
  Future<String> verifyResetCode(String correo, String code);
  Future<AuthSessionEntity?> resetPassword(
      String correo, String resetToken, String nuevaContrasena);
  Future<PerfilEntity> getPerfil();
  Future<PerfilEntity> actualizarPerfil({String? nombre, String? telefono});
}
