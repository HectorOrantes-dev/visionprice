import '../entities/unirse_result_entity.dart';
import '../repositories/collaboration_repository.dart';

class UnirseAProyectoUseCase {
  final CollaborationRepository _repo;
  UnirseAProyectoUseCase(this._repo);

  Future<UnirseResultEntity> call(String codigo) =>
      _repo.unirseAProyecto(codigo);
}
