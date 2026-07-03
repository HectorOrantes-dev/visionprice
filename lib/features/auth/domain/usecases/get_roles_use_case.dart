import 'package:injectable/injectable.dart';

import '../entities/role_entity.dart';
import '../repositories/auth_repository.dart';

/// Lista los roles disponibles para la pantalla de registro.
@injectable
class GetRolesUseCase {
  final AuthRepository _repo;
  GetRolesUseCase(this._repo);

  Future<List<RoleEntity>> call() => _repo.getRoles();
}
