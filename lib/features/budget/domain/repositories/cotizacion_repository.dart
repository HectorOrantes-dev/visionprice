import '../entities/cotizacion_entity.dart';
import '../entities/producto_entity.dart';

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
    required List<ItemCotizacion> items,
  });

  /// Obtiene el PDF de la cotización (respuesta JSON del back-end).
  Future<Map<String, dynamic>> pdf(int cotizacionId);
}
