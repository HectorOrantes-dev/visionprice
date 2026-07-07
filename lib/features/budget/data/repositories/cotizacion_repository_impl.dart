import 'package:injectable/injectable.dart';

import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/repositories/cotizacion_repository.dart';
import '../datasources/cotizacion_remote_datasource.dart';

@LazySingleton(as: CotizacionRepository)
class CotizacionRepositoryImpl implements CotizacionRepository {
  final CotizacionRemoteDataSource _remote;
  CotizacionRepositoryImpl(this._remote);

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
    required List<ItemCotizacion> items,
  }) {
    final bool usingNewFormat = items.any((item) => item.areaM2 != null);
    
    return _remote.crear({
      'proyecto_id': proyectoId,
      if (!usingNewFormat && pisoM2 != null) 'piso_m2': pisoM2,
      if (!usingNewFormat && paredesM2 != null) 'paredes_m2': paredesM2,
      'items': items.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<Map<String, dynamic>> pdf(int cotizacionId) =>
      _remote.pdf(cotizacionId);
}
