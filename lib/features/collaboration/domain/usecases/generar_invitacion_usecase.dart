import '../entities/invitacion_entity.dart';
import '../repositories/collaboration_repository.dart';

class GenerarInvitacionUseCase {
  final CollaborationRepository _repo;
  GenerarInvitacionUseCase(this._repo);

  Future<InvitacionEntity> call(int proyectoId, {List<String>? correos}) =>
      _repo.generarInvitacion(proyectoId, correos);
}
