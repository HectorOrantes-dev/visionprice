import '../../domain/entities/auditoria_resultado_entity.dart';
import '../../domain/repositories/auditoria_repository.dart';
import '../datasources/auditoria_remote_datasource.dart';

class AuditoriaRepositoryImpl implements AuditoriaRepository {
  final AuditoriaRemoteDataSource _remote;
  AuditoriaRepositoryImpl(this._remote);

  @override
  Future<AuditoriaResultadoEntity> auditarPresupuesto(int presupuestoId) =>
      _remote.auditarPresupuesto(presupuestoId);

  @override
  Future<AuditoriaResultadoEntity> anomaliasZona({
    required double lat,
    required double lng,
  }) =>
      _remote.anomaliasZona(lat: lat, lng: lng);
}
