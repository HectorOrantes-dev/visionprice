import '../../domain/entities/entrenamiento_entity.dart';
import '../../domain/entities/recomendacion_kit_entity.dart';

abstract class RecomendacionRemoteDataSource {
  /// `POST /api/v1/recomendaciones/entrenar` (sin body). Solo rol
  /// `ingeniero_civil`; el back-end responde 403 para los demás.
  Future<EntrenamientoEntity> entrenar();

  /// `POST /api/v1/recomendaciones/kit` — cualquier rol autenticado.
  /// [proyectoId] se manda siempre que exista: es lo que permite que la
  /// recomendación cuente como "real" al cerrar el loop.
  Future<RecomendacionKitEntity> recomendarKit({
    required double lat,
    required double lng,
    required String categoria,
    required double areaM2,
    int? proyectoId,
    int? k,
  });
}
