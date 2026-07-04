import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/producto_entity.dart';

abstract class CotizacionRemoteDataSource {
  Future<CotizacionEntity> crear(Map<String, dynamic> body);
  Future<List<ProductoEntity>> productos(
      double lat, double lng, double? radioKm, String? categoria);
  Future<Map<String, dynamic>> pdf(int cotizacionId);
}
