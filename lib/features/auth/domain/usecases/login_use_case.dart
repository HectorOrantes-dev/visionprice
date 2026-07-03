import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

/// Paso 1 del login con correo: dispara el envío del código 2FA.
@injectable
class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<void> call({required String correo, required String contrasena}) =>
      _repo.login(correo: correo, contrasena: contrasena);
}
