import '../entities/auth_session_entity.dart';
import '../entities/perfil_entity.dart';
import '../entities/register_result_entity.dart';
import '../entities/role_entity.dart';
import '../repositories/auth_repository.dart';

/// Cada caso de uso encapsula UNA acción del negocio y depende solo del
/// contrato [AuthRepository]. Son `@injectable` (factory): instancias ligeras
/// y sin estado, baratas de recrear. Injectable las inyecta automáticamente
/// resolviendo el `AuthRepository` registrado.

class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  /// Devuelve la sesión si el login fue directo (sin 2FA), o `null` si el
  /// back-end envió un código de verificación que hay que confirmar.
  Future<AuthSessionEntity?> call({
    required String correo,
    required String contrasena,
  }) =>
      _repo.login(correo: correo, contrasena: contrasena);
}

class VerifyTwoFactorUseCase {
  final AuthRepository _repo;
  VerifyTwoFactorUseCase(this._repo);

  Future<AuthSessionEntity> call({
    required String correo,
    required String code,
  }) =>
      _repo.verifyTwoFactor(correo: correo, code: code);
}

class GetRolesUseCase {
  final AuthRepository _repo;
  GetRolesUseCase(this._repo);

  Future<List<RoleEntity>> call() => _repo.getRoles();
}

class RegisterUseCase {
  final AuthRepository _repo;
  RegisterUseCase(this._repo);

  Future<RegisterResultEntity> call({
    required String nombre,
    required String correo,
    required String contrasena,
    required String rol,
    String? telefono,
  }) =>
      _repo.register(
        nombre: nombre,
        correo: correo,
        contrasena: contrasena,
        rol: rol,
        telefono: telefono,
      );
}

class GoogleLoginUseCase {
  final AuthRepository _repo;
  GoogleLoginUseCase(this._repo);

  Future<AuthSessionEntity> call({required String idToken}) =>
      _repo.googleLogin(idToken: idToken);
}

class GoogleRegisterUseCase {
  final AuthRepository _repo;
  GoogleRegisterUseCase(this._repo);

  Future<AuthSessionEntity> call({
    required String idToken,
    required String rol,
  }) =>
      _repo.googleRegister(idToken: idToken, rol: rol);
}

class ForgotPasswordUseCase {
  final AuthRepository _repo;
  ForgotPasswordUseCase(this._repo);

  Future<void> call({required String correo}) =>
      _repo.forgotPassword(correo: correo);
}

class VerifyResetCodeUseCase {
  final AuthRepository _repo;
  VerifyResetCodeUseCase(this._repo);

  Future<String> call({
    required String correo,
    required String code,
  }) =>
      _repo.verifyResetCode(correo: correo, code: code);
}

class ResetPasswordUseCase {
  final AuthRepository _repo;
  ResetPasswordUseCase(this._repo);

  Future<AuthSessionEntity?> call({
    required String correo,
    required String resetToken,
    required String nuevaContrasena,
  }) =>
      _repo.resetPassword(
        correo: correo,
        resetToken: resetToken,
        nuevaContrasena: nuevaContrasena,
      );
}

class GetPerfilUseCase {
  final AuthRepository _repo;
  GetPerfilUseCase(this._repo);

  Future<PerfilEntity> call({bool forceRefresh = false}) =>
      _repo.getPerfil(forceRefresh: forceRefresh);
}

class ActualizarPerfilUseCase {
  final AuthRepository _repo;
  ActualizarPerfilUseCase(this._repo);

  Future<PerfilEntity> call({String? nombre, String? telefono}) =>
      _repo.actualizarPerfil(nombre: nombre, telefono: telefono);
}

class LogoutUseCase {
  final AuthRepository _repo;
  LogoutUseCase(this._repo);

  Future<void> call() => _repo.logout();
}
