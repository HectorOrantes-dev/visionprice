
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/item_cotizacion.dart';
import '../../domain/entities/material_regla_entity.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/entities/superficie_kit_item.dart';
import '../../domain/repositories/cotizacion_repository.dart';
import '../datasources/cotizacion_remote_datasource.dart';

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
    return _remote.crear({
      'proyecto_id': proyectoId,
      'piso_m2': pisoM2,       // siempre presente (null si no aplica)
      'paredes_m2': paredesM2, // siempre presente (null si no aplica)
      'items': items.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<CotizacionEntity> crearKit({
    required int proyectoId,
    required List<SuperficieKitItem> superficies,
  }) {
    return _remote.crearKit({
      'proyecto_id': proyectoId,
      'superficies': superficies.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<List<MaterialReglaEntity>> materiales() => _remote.materiales();

  @override
  Future<Map<String, dynamic>> pdf(int cotizacionId) =>
      _remote.pdf(cotizacionId);
}
