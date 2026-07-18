import '../entities/invitacion_entity.dart';
import '../entities/miembros_result_entity.dart';
import '../entities/unirse_result_entity.dart';

/// Contrato de la feature colaboración. Los métodos devuelven el valor directo
/// y lanzan `ApiException` en error (igual que el resto de repos del proyecto);
/// no se usa `Either/Failure`. La captura la hace `AsyncValue.guard` en los
/// notifiers de presentación.
abstract class CollaborationRepository {
  Future<MiembrosResultEntity> obtenerMiembros(int proyectoId);
  Future<void> quitarMiembro(int proyectoId, int usuarioId);
  Future<InvitacionEntity> generarInvitacion(
    int proyectoId,
    String rol,
    List<String>? correos,
  );
  Future<List<InvitacionEntity>> obtenerInvitaciones(int proyectoId);
  Future<void> revocarInvitacion(int proyectoId, int invitacionId);
  Future<UnirseResultEntity> unirseAProyecto(String codigo);
}
