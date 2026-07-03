import 'package:injectable/injectable.dart';

import '../entities/auth_session_entity.dart';
import '../entities/perfil_entity.dart';
import '../entities/register_result_entity.dart';
import '../entities/role_entity.dart';
import '../repositories/auth_repository.dart';

/// Cada caso de uso encapsula UNA acción del negocio y depende solo del
/// contrato [AuthRepository]. Son `@injectable` (factory): instancias ligeras
/// y sin estado, baratas de recrear. Injectable las inyecta automáticamente
/// resolviendo el `AuthRepository` registrado.

@injectable
class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<void> call({required String correo, required String contrasena}) =>
      _repo.login(correo: correo, contrasena: contrasena);
}

@injectable
class VerifyTwoFactorUseCase {
  final AuthRepository _repo;
  VerifyTwoFactorUseCase(this._repo);

  Future<AuthSessionEntity> call({
    required String correo,
    required String code,
  }) =>
      _repo.verifyTwoFactor(correo: correo, code: code);
}

@injectable
class GetRolesUseCase {
  final AuthRepository _repo;
  GetRolesUseCase(this._repo);

  Future<List<RoleEntity>> call() => _repo.getRoles();
}

@injectable
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

@injectable
class GoogleLoginUseCase {
  final AuthRepository _repo;
  GoogleLoginUseCase(this._repo);

  Future<AuthSessionEntity> call({required String idToken}) =>
      _repo.googleLogin(idToken: idToken);
}

@injectable
class GoogleRegisterUseCase {
  final AuthRepository _repo;
  GoogleRegisterUseCase(this._repo);

  Future<AuthSessionEntity> call({
    required String idToken,
    required String rol,
  }) =>
      _repo.googleRegister(idToken: idToken, rol: rol);
}

@injectable
class ForgotPasswordUseCase {
  final AuthRepository _repo;
  ForgotPasswordUseCase(this._repo);

  Future<void> call({required String correo}) =>
      _repo.forgotPassword(correo: correo);
}

@injectable
class VerifyResetCodeUseCase {
  final AuthRepository _repo;
  VerifyResetCodeUseCase(this._repo);

  Future<String> call({
    required String correo,
    required String code,
  }) =>
      _repo.verifyResetCode(correo: correo, code: code);
}

@injectable
class ResetPasswordUseCase {
  final AuthRepository _repo;
  ResetPasswordUseCase(this._repo);

  Future<void> call({
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

@injectable
class GetPerfilUseCase {
  final AuthRepository _repo;
  GetPerfilUseCase(this._repo);

  Future<PerfilEntity> call({bool forceRefresh = false}) =>
      _repo.getPerfil(forceRefresh: forceRefresh);
}

@injectable
class LogoutUseCase {
  final AuthRepository _repo;
  LogoutUseCase(this._repo);

  Future<void> call() => _repo.logout();
}
