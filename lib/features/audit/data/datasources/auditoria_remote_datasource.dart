import '../../domain/entities/auditoria_resultado_entity.dart';

abstract class AuditoriaRemoteDataSource {
  /// Todas las líneas de un presupuesto, anómalas o no
  /// (usar `analisis.esAnomalia` para resaltar).
  Future<AuditoriaResultadoEntity> auditarPresupuesto(int presupuestoId);

  /// Solo las líneas anómalas cerca de [lat]/[lng] (ya viene pre-filtrado).
  Future<AuditoriaResultadoEntity> anomaliasZona({
    required double lat,
    required double lng,
  });
}
