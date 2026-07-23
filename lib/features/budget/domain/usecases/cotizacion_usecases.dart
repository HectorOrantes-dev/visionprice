import '../entities/cotizacion_entity.dart';
import '../entities/item_cotizacion.dart';
import '../entities/producto_entity.dart';
import '../repositories/cotizacion_repository.dart';

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

class CrearCotizacionUseCase {
  final CotizacionRepository _repo;
  CrearCotizacionUseCase(this._repo);

  Future<CotizacionEntity> call({
    required int proyectoId,
    double? pisoM2,
    double? paredesM2,
    double? manoObra,
    required List<ItemCotizacion> items,
  }) =>
      _repo.crear(
        proyectoId: proyectoId,
        pisoM2: pisoM2,
        paredesM2: paredesM2,
        manoObra: manoObra,
        items: items,
      );
}

class ObtenerPdfUseCase {
  final CotizacionRepository _repo;
  ObtenerPdfUseCase(this._repo);

  Future<Map<String, dynamic>> call(int cotizacionId) =>
      _repo.pdf(cotizacionId);
}
