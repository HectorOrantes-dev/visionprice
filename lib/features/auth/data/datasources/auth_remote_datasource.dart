import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/entities/register_result_entity.dart';
import '../../domain/entities/role_entity.dart';

// La implementación vive en su propio archivo (una clase por archivo, SRP);
// se re-exporta para no romper imports existentes ni la DI generada.
export 'auth_remote_datasource_impl.dart';

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
  Future<void> forgotPassword(String correo);
  Future<void> resetPassword(String correo, String code, String nuevaContrasena);
  Future<PerfilEntity> getPerfil();
}
