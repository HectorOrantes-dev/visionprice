import 'package:injectable/injectable.dart';

import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';

/// Paso 2 del login: verifica el código 2FA y devuelve la sesión.
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
