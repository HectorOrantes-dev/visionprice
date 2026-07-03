import 'package:injectable/injectable.dart';

import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';

/// Login con Google. Lanza `ApiException(404)` si el usuario no existe.
@injectable
class GoogleLoginUseCase {
  final AuthRepository _repo;
  GoogleLoginUseCase(this._repo);

  Future<AuthSessionEntity> call({required String idToken}) =>
      _repo.googleLogin(idToken: idToken);
}
