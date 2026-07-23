import '../entities/uso_cotizaciones_entity.dart';
import '../repositories/cotizacion_repository.dart';

class ObtenerUsoCotizacionesUseCase {
  final CotizacionRepository _repo;
  ObtenerUsoCotizacionesUseCase(this._repo);

  Future<UsoCotizacionesEntity> call() => _repo.uso();
}
