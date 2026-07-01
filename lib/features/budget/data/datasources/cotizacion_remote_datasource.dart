import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/producto_entity.dart';

abstract class CotizacionRemoteDataSource {
  Future<List<ProductoEntity>> productos(
      double lat, double lng, double? radioKm, String? categoria);
  Future<CotizacionEntity> crear(Map<String, dynamic> body);
  Future<Map<String, dynamic>> pdf(int cotizacionId);
}

@LazySingleton(as: CotizacionRemoteDataSource)
class CotizacionRemoteDataSourceImpl implements CotizacionRemoteDataSource {
  final ApiClient _client;
  CotizacionRemoteDataSourceImpl(this._client);

  @override
  Future<List<ProductoEntity>> productos(
      double lat, double lng, double? radioKm, String? categoria) async {
    final data = await _client.getJsonList(
      ApiConfig.cotizacionesProductos,
      auth: true,
      query: {
        'lat': lat,
        'lng': lng,
        if (radioKm != null) 'radio_km': radioKm,
        if (categoria != null) 'categoria': categoria,
      },
    );
    return data
        .whereType<Map<String, dynamic>>()
        .map(ProductoEntity.fromJson)
        .toList();
  }

  @override
  Future<CotizacionEntity> crear(Map<String, dynamic> body) async {
    final data = await _client.postJson(ApiConfig.cotizaciones, body, auth: true);
    return CotizacionEntity.fromJson(data);
  }

  @override
  Future<Map<String, dynamic>> pdf(int cotizacionId) {
    return _client.getJson(ApiConfig.cotizacionPdf(cotizacionId), auth: true);
  }
}
