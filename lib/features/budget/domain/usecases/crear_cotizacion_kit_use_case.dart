
import '../entities/cotizacion_entity.dart';
import '../entities/superficie_kit_item.dart';
import '../repositories/cotizacion_repository.dart';

/// Crea una cotización tipo KIT (loseta/piso/azulejo/zoclo + complementos).
class CrearCotizacionKitUseCase {
  final CotizacionRepository _repo;
  CrearCotizacionKitUseCase(this._repo);

  Future<CotizacionEntity> call({
    required int proyectoId,
    double? manoObra,
    required List<SuperficieKitItem> superficies,
  }) =>
      _repo.crearKit(
          proyectoId: proyectoId, manoObra: manoObra, superficies: superficies);
}
