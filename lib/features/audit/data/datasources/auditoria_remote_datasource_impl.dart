import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/auditoria_resultado_entity.dart';
import 'auditoria_remote_datasource.dart';

class AuditoriaRemoteDataSourceImpl implements AuditoriaRemoteDataSource {
  final ApiClient _client;
  AuditoriaRemoteDataSourceImpl(this._client);

  @override
  Future<AuditoriaResultadoEntity> auditarPresupuesto(int presupuestoId) async {
    final data = await _client.getJson(
      ApiConfig.auditoriaPrecioPresupuesto(presupuestoId),
      auth: true,
    );
    return AuditoriaResultadoEntity.fromJson(data);
  }

  @override
  Future<AuditoriaResultadoEntity> anomaliasZona({
    required double lat,
    required double lng,
  }) async {
    final data = await _client.getJson(
      ApiConfig.auditoriaPrecioAnomalias,
      auth: true,
      query: {'lat': lat, 'lng': lng},
    );
    return AuditoriaResultadoEntity.fromJson(data);
  }
}
