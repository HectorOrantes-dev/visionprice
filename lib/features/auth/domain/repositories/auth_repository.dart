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

  /// Paso 1 de recuperar contraseña: envía un código al correo (si existe).
  /// Responde igual exista o no el correo (anti-enumeración).
  Future<void> forgotPassword({required String correo});

  /// Paso 2: verifica el código de recuperación. Devuelve el `reset_token`
  /// (JWT de un solo uso, 15 min) que autoriza el cambio de contraseña.
  /// Lanza `ApiException` si el código es inválido o expiró.
  Future<String> verifyResetCode({
    required String correo,
    required String code,
  });

  /// Paso 3: establece la nueva contraseña usando el `reset_token` obtenido en
  /// [verifyResetCode]. Lanza `ApiException` si el token es inválido o expiró.
  Future<void> resetPassword({
    required String correo,
    required String resetToken,
    required String nuevaContrasena,
  });

  /// Perfil completo del usuario autenticado (`GET /api/v1/me/perfil`),
  /// para la pantalla de "Perfil / Mi cuenta". Requiere token válido.
  /// Se cachea en memoria: solo pega a la red la primera vez o si
  /// [forceRefresh] es `true`.
  Future<PerfilEntity> getPerfil({bool forceRefresh = false});

  /// Cierra la sesión local (borra el token).
  Future<void> logout();
}
