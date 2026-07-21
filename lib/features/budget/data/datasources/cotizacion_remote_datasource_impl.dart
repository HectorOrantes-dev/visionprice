import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/borrador_cotizacion_entity.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/cotizacion_pdf_entity.dart';
import '../../domain/entities/material_regla_entity.dart';
import '../../domain/entities/producto_entity.dart';
import 'cotizacion_remote_datasource.dart';

class CotizacionRemoteDataSourceImpl implements CotizacionRemoteDataSource {
  final ApiClient _client;
  CotizacionRemoteDataSourceImpl(this._client);

  @override
  Future<List<ProductoEntity>> productos(
      double lat, double lng, double? radioKm, String? categoria) async {
    if (kDebugMode) {
      debugPrint('🛰️ REQ /cotizaciones/productos lat=$lat lng=$lng '
          'radio_km=${radioKm ?? '(default)'} categoria=${categoria ?? '(ninguna)'}');
    }
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

  @override
  Future<List<CotizacionPdfEntity>> listarPdfs() async {
    final data = await _client.getJsonList(ApiConfig.cotizacionesPdfs, auth: true);
    return data
        .whereType<Map<String, dynamic>>()
        .map(CotizacionPdfEntity.fromJson)
        .toList();
  }

  @override
  Future<Uint8List> pdfBytes(int cotizacionId) {
    // Se usa la ruta conocida + baseUrl de la app (no la URL absoluta del back)
    // para respetar el dominio configurado y adjuntar el Bearer token.
    return _client.getBytes(ApiConfig.cotizacionPdf(cotizacionId), auth: true);
  }

  @override
  Future<BorradorCotizacionEntity> borrador(int grabacionId) async {
    final data = await _client.postJson(
      ApiConfig.cotizacionesBorrador,
      {'grabacion_id': grabacionId},
      auth: true,
    );
    return BorradorCotizacionEntity.fromJson(data);
  }
}
