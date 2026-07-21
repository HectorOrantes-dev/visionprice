import '../entities/auditoria_resultado_entity.dart';

abstract class AuditoriaRepository {
  Future<AuditoriaResultadoEntity> auditarPresupuesto(int presupuestoId);
  Future<AuditoriaResultadoEntity> anomaliasZona({
    required double lat,
    required double lng,
  });
}
