import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/material_regla_entity.dart';
import '../../domain/entities/producto_entity.dart';
import 'cotizacion_remote_datasource.dart';

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
    // Diagnóstico (solo debug): imprime el JSON crudo tal como llega al
    // dispositivo, para verificar la clave/URL real de la imagen (punto 3).
    if (kDebugMode) {
      debugPrint('🛰️ /cotizaciones/productos → ${data.length} productos');
      final first = data.whereType<Map<String, dynamic>>().firstOrNull;
      if (first != null) {
        debugPrint('   claves: ${first.keys.toList()}');
        debugPrint('   image_url crudo: ${first['image_url']}');
      }
    }

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
  Future<CotizacionEntity> crearKit(Map<String, dynamic> body) async {
    final data = await _client.postJson(ApiConfig.cotizacionesKit, body, auth: true);
    return CotizacionEntity.fromJson(data);
  }

  @override
  Future<List<MaterialReglaEntity>> materiales() async {
    final data = await _client.getJsonList(ApiConfig.cotizacionesMateriales, auth: true);
    return data
        .whereType<Map<String, dynamic>>()
        .map(MaterialReglaEntity.fromJson)
        .toList();
  }

  @override
  Future<Map<String, dynamic>> pdf(int cotizacionId) {
    return _client.getJson(ApiConfig.cotizacionPdf(cotizacionId), auth: true);
  }
}
