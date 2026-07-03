import 'package:injectable/injectable.dart';

import '../entities/cotizacion_entity.dart';
import '../repositories/cotizacion_repository.dart';

/// Crea una cotización a partir de m² e ítems.
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
