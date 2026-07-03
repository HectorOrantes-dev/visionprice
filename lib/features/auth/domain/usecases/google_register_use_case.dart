import 'package:injectable/injectable.dart';

import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';

/// Registro con Google (requiere el rol elegido en el selector).
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
