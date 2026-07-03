import 'package:injectable/injectable.dart';

import '../entities/producto_entity.dart';
import '../repositories/cotizacion_repository.dart';

/// Productos cercanos para armar la cotización.
@injectable
class ObtenerProductosUseCase {
  final CotizacionRepository _repo;
  ObtenerProductosUseCase(this._repo);

  Future<List<ProductoEntity>> call({
    required double lat,
    required double lng,
    double? radioKm,
    String? categoria,
  }) =>
      _repo.productos(
          lat: lat, lng: lng, radioKm: radioKm, categoria: categoria);
}
