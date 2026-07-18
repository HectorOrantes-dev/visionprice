import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/entrenamiento_entity.dart';
import '../../domain/entities/recomendacion_kit_entity.dart';
import 'recomendacion_remote_datasource.dart';

class RecomendacionRemoteDataSourceImpl implements RecomendacionRemoteDataSource {
  final ApiClient _client;
  RecomendacionRemoteDataSourceImpl(this._client);

  @override
  Future<EntrenamientoEntity> entrenar() async {
    final data = await _client.postJson(
      ApiConfig.recomendacionesEntrenar,
      const {}, // sin body
      auth: true,
    );
    return EntrenamientoEntity.fromJson(data);
  }

  @override
  Future<RecomendacionKitEntity> recomendarKit({
    required double lat,
    required double lng,
    required String categoria,
    required double areaM2,
    int? proyectoId,
    int? k,
  }) async {
    final data = await _client.postJson(
      ApiConfig.recomendacionesKit,
      {
        'lat': lat,
        'lng': lng,
        'categoria': categoria,
        'area_m2': areaM2,
        if (proyectoId != null) 'proyecto_id': proyectoId,
        if (k != null) 'k': k,
      },
      auth: true,
    );
    return RecomendacionKitEntity.fromJson(data);
  }
}
