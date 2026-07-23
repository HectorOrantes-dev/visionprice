import 'package:flutter/foundation.dart';

import '../../domain/entities/borrador_cotizacion_entity.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/cotizacion_pdf_entity.dart';
import '../../domain/entities/item_cotizacion.dart';
import '../../domain/entities/material_regla_entity.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/entities/superficie_kit_item.dart';
import '../../domain/entities/uso_cotizaciones_entity.dart';
import '../../domain/repositories/cotizacion_repository.dart';
import '../datasources/cotizacion_pdf_local_datasource.dart';
import '../datasources/cotizacion_remote_datasource.dart';

class CotizacionRepositoryImpl implements CotizacionRepository {
  final CotizacionRemoteDataSource _remote;
  final CotizacionPdfLocalDataSource _pdfLocal;
  CotizacionRepositoryImpl(this._remote, this._pdfLocal);

  @override
  Future<List<ProductoEntity>> productos({
    required double lat,
    required double lng,
    double? radioKm,
    String? categoria,
  }) =>
      _remote.productos(lat, lng, radioKm, categoria);

  @override
  Future<CotizacionEntity> crear({
    required int proyectoId,
    double? pisoM2,
    double? paredesM2,
    double? manoObra,
    required List<ItemCotizacion> items,
  }) {
    return _remote.crear({
      'proyecto_id': proyectoId,
      'piso_m2': pisoM2, // siempre presente (null si no aplica)
      'paredes_m2': paredesM2, // siempre presente (null si no aplica)
      if (manoObra != null) 'mano_obra': manoObra,
      'items': items.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<CotizacionEntity> crearKit({
    required int proyectoId,
    double? manoObra,
    int? recomendacionId,
    required List<SuperficieKitItem> superficies,
  }) {
    return _remote.crearKit({
      'proyecto_id': proyectoId,
      if (manoObra != null) 'mano_obra': manoObra,
      // Opcional: solo si hubo recomendación para esta cotización.
      if (recomendacionId != null) 'recomendacion_id': recomendacionId,
      'superficies': superficies.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<List<MaterialReglaEntity>> materiales() => _remote.materiales();

  @override
  Future<Map<String, dynamic>> pdf(int cotizacionId) =>
      _remote.pdf(cotizacionId);

  /// Remote-first con caché local: si el back-end responde, se guarda el
  /// snapshot en sqflite y se devuelve; si falla (sin internet), se devuelve lo
  /// último cacheado. Solo propaga el error si tampoco hay caché.
  @override
  Future<List<CotizacionPdfEntity>> listarPdfs() async {
    try {
      final remotos = await _remote.listarPdfs();
      await _pdfLocal.guardar(remotos);
      return remotos;
    } catch (e) {
      debugPrint('MIS COTIZACIONES: back-end falló, uso caché local -> $e');
      final locales = await _pdfLocal.leer();
      if (locales.isNotEmpty) return locales;
      rethrow; // sin caché: que la UI muestre el AsyncError.
    }
  }

  @override
  Future<List<CotizacionPdfEntity>> listarPdfsLocales() => _pdfLocal.leer();

  @override
  Future<Uint8List> pdfBytes(int cotizacionId) =>
      _remote.pdfBytes(cotizacionId);

  @override
  Future<BorradorCotizacionEntity> borrador(int grabacionId) =>
      _remote.borrador(grabacionId);

  @override
  Future<UsoCotizacionesEntity> uso() => _remote.uso();
}
