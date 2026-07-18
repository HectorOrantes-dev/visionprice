import '../entities/invitacion_entity.dart';
import '../repositories/collaboration_repository.dart';

class GenerarInvitacionUseCase {
  final CollaborationRepository _repo;
  GenerarInvitacionUseCase(this._repo);

  Future<InvitacionEntity> call(int proyectoId, String rol,
          {List<String>? correos}) =>
      _repo.generarInvitacion(proyectoId, rol, correos);
}
