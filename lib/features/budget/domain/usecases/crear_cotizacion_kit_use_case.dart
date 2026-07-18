
import '../entities/cotizacion_entity.dart';
import '../entities/superficie_kit_item.dart';
import '../repositories/cotizacion_repository.dart';

/// Crea una cotización tipo KIT (loseta/piso/azulejo/zoclo + complementos).
class CrearCotizacionKitUseCase {
  final CotizacionRepository _repo;
  CrearCotizacionKitUseCase(this._repo);

  /// [recomendacionId] solo se manda si el usuario pidió una recomendación para
  /// esta cotización ("Usar recomendados"); es opcional en el back-end.
  Future<CotizacionEntity> call({
    required int proyectoId,
    double? manoObra,
    int? recomendacionId,
    required List<SuperficieKitItem> superficies,
  }) =>
      _repo.crearKit(
        proyectoId: proyectoId,
        manoObra: manoObra,
        recomendacionId: recomendacionId,
        superficies: superficies,
      );
}
