import '../entities/miembro_entity.dart';
import '../repositories/collaboration_repository.dart';

class ObtenerMiembrosUseCase {
  final CollaborationRepository _repo;
  ObtenerMiembrosUseCase(this._repo);

  Future<List<MiembroEntity>> call(int proyectoId) =>
      _repo.obtenerMiembros(proyectoId);
}
