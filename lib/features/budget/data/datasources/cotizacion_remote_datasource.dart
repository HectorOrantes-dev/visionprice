import 'dart:typed_data';

import '../../domain/entities/borrador_cotizacion_entity.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/cotizacion_pdf_entity.dart';
import '../../domain/entities/material_regla_entity.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/entities/uso_cotizaciones_entity.dart';

abstract class CotizacionRemoteDataSource {
  Future<CotizacionEntity> crear(Map<String, dynamic> body);
  Future<CotizacionEntity> crearKit(Map<String, dynamic> body);
  Future<List<ProductoEntity>> productos(
      double lat, double lng, double? radioKm, String? categoria);
  Future<List<MaterialReglaEntity>> materiales();
  Future<Map<String, dynamic>> pdf(int cotizacionId);
  Future<BorradorCotizacionEntity> borrador(int grabacionId);

  /// Cuota gratis de cotizaciones: cuántas lleva, cuántas le quedan.
  Future<UsoCotizacionesEntity> uso();

  /// Todas las cotizaciones/PDFs del usuario (todas sus obras).
  Future<List<CotizacionPdfEntity>> listarPdfs();

  /// Bytes del PDF de una cotización (descarga desde su enlace real).
  Future<Uint8List> pdfBytes(int cotizacionId);
}
