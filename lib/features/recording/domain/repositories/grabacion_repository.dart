import '../entities/calculo_entity.dart';
import '../entities/grabacion_entity.dart';

/// Contrato del flujo de audio del maestro de obra.
abstract class GrabacionRepository {
  /// Sube el audio grabado (multipart) → devuelve `{id, estado: procesando}`.
  Future<GrabacionEntity> subir({
    required String audioPath,
    int? duracionSegundos,
    int? proyectoId,
  });

  /// Detalle (para sondeo): estado + transcripción + extracción + confianza.
  Future<GrabacionEntity> detalle(int id);

  /// Historial de grabaciones del usuario.
  Future<List<GrabacionEntity>> historial();

  /// Calcula m² a partir de la grabación ya transcrita (o texto editado).
  Future<CalculoEntity> calcular({int? grabacionId, String? texto});

  /// Actualiza el texto de la transcripción en el servidor.
  Future<GrabacionEntity> actualizarTranscripcion(int id, String texto);
}
