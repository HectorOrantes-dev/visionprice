import 'package:injectable/injectable.dart';

import '../entities/perfil_entity.dart';
import '../repositories/auth_repository.dart';

/// Perfil completo del usuario (cacheado; [forceRefresh] pega a la red).
@injectable
class GetPerfilUseCase {
  final AuthRepository _repo;
  GetPerfilUseCase(this._repo);

  Future<PerfilEntity> call({bool forceRefresh = false}) =>
      _repo.getPerfil(forceRefresh: forceRefresh);
}
