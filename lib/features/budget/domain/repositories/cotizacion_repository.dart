import 'dart:typed_data';

import '../entities/cotizacion_entity.dart';
import '../entities/cotizacion_pdf_entity.dart';
import '../entities/item_cotizacion.dart';
import '../entities/material_regla_entity.dart';
import '../entities/producto_entity.dart';
import '../entities/superficie_kit_item.dart';

abstract class CotizacionRepository {
  /// Productos/ferreterías cercanas a una ubicación.
  Future<List<ProductoEntity>> productos({
    required double lat,
    required double lng,
    double? radioKm,
    String? categoria,
  });

  /// Crea la cotización con los productos elegidos y las superficies (m²).
  Future<CotizacionEntity> crear({
    required int proyectoId,
    double? pisoM2,
    double? paredesM2,
    double? manoObra,
    required List<ItemCotizacion> items,
  });

  /// Crea una cotización tipo KIT (loseta/piso/azulejo/zoclo + complementos).
  /// [recomendacionId] cierra el loop del modelo: solo se manda si el usuario
  /// pidió la recomendación ("Usar recomendados").
  Future<CotizacionEntity> crearKit({
    required int proyectoId,
    double? manoObra,
    int? recomendacionId,
    required List<SuperficieKitItem> superficies,
  });

  /// Reglas por categoría: simple (rendimiento) o kit + complementos.
  Future<List<MaterialReglaEntity>> materiales();

  /// Obtiene el PDF de la cotización (respuesta JSON del back-end).
  Future<Map<String, dynamic>> pdf(int cotizacionId);

  /// Todas las cotizaciones/PDFs del usuario (todas sus obras): pide al
  /// back-end, guarda el snapshot en local y devuelve lo fresco. Si el back-end
  /// falla, devuelve la caché local.
  Future<List<CotizacionPdfEntity>> listarPdfs();

  /// Solo la caché local (sin red): sirve para pintar la pantalla al instante.
  Future<List<CotizacionPdfEntity>> listarPdfsLocales();

  /// Bytes del PDF de una cotización, para descargar/compartir en el dispositivo.
  Future<Uint8List> pdfBytes(int cotizacionId);
}
