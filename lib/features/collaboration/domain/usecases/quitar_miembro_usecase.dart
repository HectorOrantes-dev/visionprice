import '../repositories/collaboration_repository.dart';

class QuitarMiembroUseCase {
  final CollaborationRepository _repo;
  QuitarMiembroUseCase(this._repo);

  Future<void> call(int proyectoId, int usuarioId) =>
      _repo.quitarMiembro(proyectoId, usuarioId);
}
