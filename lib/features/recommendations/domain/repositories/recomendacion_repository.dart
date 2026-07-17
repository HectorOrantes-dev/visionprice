import '../entities/entrenamiento_entity.dart';
import '../entities/recomendacion_kit_entity.dart';

abstract class RecomendacionRepository {
  /// Entrena los modelos con las obras acumuladas (reales + sintéticas).
  /// Solo rol `ingeniero_civil`.
  Future<EntrenamientoEntity> entrenar();

  /// Recomienda tipo de kit, complementos y método de crucetas para una zona.
  Future<RecomendacionKitEntity> recomendarKit({
    required double lat,
    required double lng,
    required String categoria,
    required double areaM2,
    int? proyectoId,
    int? k,
  });
}
