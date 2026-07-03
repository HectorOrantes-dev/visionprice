import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/producto_entity.dart';

// La implementación vive en su propio archivo (una clase por archivo, SRP);
// se re-exporta para no romper imports existentes ni la DI generada.
export 'cotizacion_remote_datasource_impl.dart';

abstract class CotizacionRemoteDataSource {
  Future<List<ProductoEntity>> productos(
      double lat, double lng, double? radioKm, String? categoria);
  Future<CotizacionEntity> crear(Map<String, dynamic> body);
  Future<Map<String, dynamic>> pdf(int cotizacionId);
}
