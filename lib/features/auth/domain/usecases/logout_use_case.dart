import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

/// Cierra la sesión local (borra el token).
@injectable
class LogoutUseCase {
  final AuthRepository _repo;
  LogoutUseCase(this._repo);

  Future<void> call() => _repo.logout();
}
