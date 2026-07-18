import '../repositories/collaboration_repository.dart';

class RevocarInvitacionUseCase {
  final CollaborationRepository _repo;
  RevocarInvitacionUseCase(this._repo);

  Future<void> call(int proyectoId, int invitacionId) =>
      _repo.revocarInvitacion(proyectoId, invitacionId);
}
