import '../entities/miembros_result_entity.dart';
import '../repositories/collaboration_repository.dart';

class ObtenerMiembrosUseCase {
  final CollaborationRepository _repo;
  ObtenerMiembrosUseCase(this._repo);

  Future<MiembrosResultEntity> call(int proyectoId) =>
      _repo.obtenerMiembros(proyectoId);
}
