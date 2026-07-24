import '../entities/invitacion_entity.dart';
import '../entities/miembro_entity.dart';
import '../entities/unirse_result_entity.dart';

/// Contrato de la feature colaboración. Los métodos devuelven el valor directo
/// y lanzan `ApiException` en error (igual que el resto de repos del proyecto);
/// no se usa `Either/Failure`. La captura la hace `AsyncValue.guard` en los
/// notifiers de presentación.
abstract class CollaborationRepository {
  Future<List<MiembroEntity>> obtenerMiembros(int proyectoId);
  Future<void> quitarMiembro(int proyectoId, int usuarioId);

  /// El rol de quien se una ya no se elige: el back-end lo infiere según el
  /// rol de quien invita (contratista invita maestro_obra; arquitecto/
  /// ingeniero_civil invita contratista).
  Future<InvitacionEntity> generarInvitacion(
    int proyectoId,
    List<String>? correos,
  );
  Future<List<InvitacionEntity>> obtenerInvitaciones(int proyectoId);
  Future<void> revocarInvitacion(int proyectoId, int invitacionId);
  Future<UnirseResultEntity> unirseAProyecto(String codigo);
}
