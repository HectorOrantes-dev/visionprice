import '../entities/auditoria_resultado_entity.dart';
import '../repositories/auditoria_repository.dart';

class AuditarPresupuestoUseCase {
  final AuditoriaRepository _repo;
  AuditarPresupuestoUseCase(this._repo);

  Future<AuditoriaResultadoEntity> call(int presupuestoId) =>
      _repo.auditarPresupuesto(presupuestoId);
}

class ObtenerAnomaliasZonaUseCase {
  final AuditoriaRepository _repo;
  ObtenerAnomaliasZonaUseCase(this._repo);

  Future<AuditoriaResultadoEntity> call({
    required double lat,
    required double lng,
  }) =>
      _repo.anomaliasZona(lat: lat, lng: lng);
}
