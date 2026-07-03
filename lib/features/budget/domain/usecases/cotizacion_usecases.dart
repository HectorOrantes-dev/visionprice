import 'package:injectable/injectable.dart';

import '../entities/cotizacion_entity.dart';
import '../entities/producto_entity.dart';
import '../repositories/cotizacion_repository.dart';

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

@injectable
class CrearCotizacionUseCase {
  final CotizacionRepository _repo;
  CrearCotizacionUseCase(this._repo);

  Future<CotizacionEntity> call({
    required int proyectoId,
    double? pisoM2,
    double? paredesM2,
    required List<ItemCotizacion> items,
  }) =>
      _repo.crear(
        proyectoId: proyectoId,
        pisoM2: pisoM2,
        paredesM2: paredesM2,
        items: items,
      );
}

@injectable
class ObtenerPdfUseCase {
  final CotizacionRepository _repo;
  ObtenerPdfUseCase(this._repo);

  Future<Map<String, dynamic>> call(int cotizacionId) =>
      _repo.pdf(cotizacionId);
}
