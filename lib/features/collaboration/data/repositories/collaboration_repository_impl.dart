import '../../domain/entities/invitacion_entity.dart';
import '../../domain/entities/miembros_result_entity.dart';
import '../../domain/entities/unirse_result_entity.dart';
import '../../domain/repositories/collaboration_repository.dart';
import '../datasources/collaboration_remote_datasource.dart';

/// Passthrough delgado al datasource remoto: el `ApiClient` ya lanza
/// `ApiException` con el mensaje del back-end, que sube tal cual hasta el
/// notifier (donde `AsyncValue.guard` lo convierte en `AsyncError`).
class CollaborationRepositoryImpl implements CollaborationRepository {
  final CollaborationRemoteDataSource _remote;

  CollaborationRepositoryImpl(this._remote);

  @override
  Future<MiembrosResultEntity> obtenerMiembros(int proyectoId) =>
      _remote.obtenerMiembros(proyectoId);

  @override
  Future<void> quitarMiembro(int proyectoId, int usuarioId) =>
      _remote.quitarMiembro(proyectoId, usuarioId);

  @override
  Future<InvitacionEntity> generarInvitacion(
    int proyectoId,
    String rol,
    List<String>? correos,
  ) =>
      _remote.generarInvitacion(proyectoId, rol, correos);

  @override
  Future<List<InvitacionEntity>> obtenerInvitaciones(int proyectoId) =>
      _remote.obtenerInvitaciones(proyectoId);

  @override
  Future<void> revocarInvitacion(int proyectoId, int invitacionId) =>
      _remote.revocarInvitacion(proyectoId, invitacionId);

  @override
  Future<UnirseResultEntity> unirseAProyecto(String codigo) =>
      _remote.unirseAProyecto(codigo);
}
