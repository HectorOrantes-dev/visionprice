import 'dart:typed_data';

import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/producto_entity.dart';

abstract class CotizacionRemoteDataSource {
  Future<CotizacionEntity> crear(Map<String, dynamic> body);
  Future<List<ProductoEntity>> obtenerProductos();
  Future<Uint8List> obtenerPdf(int cotizacionId);
}
