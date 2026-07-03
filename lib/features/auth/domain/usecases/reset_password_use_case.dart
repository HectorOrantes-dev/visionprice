import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

/// Paso 2 de recuperar contraseña: verifica el código y fija la nueva.
@injectable
class ResetPasswordUseCase {
  final AuthRepository _repo;
  ResetPasswordUseCase(this._repo);

  Future<void> call({
    required String correo,
    required String code,
    required String nuevaContrasena,
  }) =>
      _repo.resetPassword(
        correo: correo,
        code: code,
        nuevaContrasena: nuevaContrasena,
      );
}
