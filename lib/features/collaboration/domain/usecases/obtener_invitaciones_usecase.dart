import '../entities/invitacion_entity.dart';
import '../repositories/collaboration_repository.dart';

class ObtenerInvitacionesUseCase {
  final CollaborationRepository _repo;
  ObtenerInvitacionesUseCase(this._repo);

  Future<List<InvitacionEntity>> call(int proyectoId) =>
      _repo.obtenerInvitaciones(proyectoId);
}
