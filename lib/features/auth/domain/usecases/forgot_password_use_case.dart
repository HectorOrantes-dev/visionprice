import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

/// Paso 1 de recuperar contraseña: envía un código al correo (si existe).
@injectable
class ForgotPasswordUseCase {
  final AuthRepository _repo;
  ForgotPasswordUseCase(this._repo);

  Future<void> call({required String correo}) =>
      _repo.forgotPassword(correo: correo);
}
