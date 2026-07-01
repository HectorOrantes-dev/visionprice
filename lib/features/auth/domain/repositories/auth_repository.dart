import '../entities/auth_session_entity.dart';
import '../entities/perfil_entity.dart';
import '../entities/register_result_entity.dart';
import '../entities/role_entity.dart';

/// Contrato de autenticación que consume la capa de dominio. La capa de datos
/// (`AuthRepositoryImpl`) lo implementa. La presentación nunca conoce la
/// implementación concreta → bajo acoplamiento, fácil de testear/mockear.
abstract class AuthRepository {
  /// Paso 1 del login con correo: dispara el envío del código 2FA al correo.
  /// No devuelve token todavía.
  Future<void> login({required String correo, required String contrasena});

  /// Paso 2: verifica el código 2FA y devuelve la sesión (token ya persistido).
  Future<AuthSessionEntity> verifyTwoFactor({
    required String correo,
    required String code,
  });

  /// Lista los roles disponibles para la pantalla de registro.
  Future<List<RoleEntity>> getRoles();

  /// Registro con correo/contraseña. Devuelve el resultado (usuario +
  /// `twoFactorSent`); si se envió código 2FA, falta verificarlo.
  Future<RegisterResultEntity> register({
    required String nombre,
    required String correo,
    required String contrasena,
    required String rol,
    String? telefono,
  });

  /// Login con Google. Lanza `ApiException(404)` si el usuario no existe
  /// (→ la UI debe mandar a registro con Google).
  Future<AuthSessionEntity> googleLogin({required String idToken});

  /// Registro con Google.
  Future<AuthSessionEntity> googleRegister({
    required String idToken,
    required String rol,
  });

  /// Perfil completo del usuario autenticado (`GET /api/v1/me/perfil`),
  /// para la pantalla de "Perfil / Mi cuenta". Requiere token válido.
  Future<PerfilEntity> getPerfil();

  /// Cierra la sesión local (borra el token).
  Future<void> logout();
}
