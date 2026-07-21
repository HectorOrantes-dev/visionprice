import '../entities/borrador_cotizacion_entity.dart';
import '../repositories/cotizacion_repository.dart';

/// Pide el borrador auto-generado (superficies + producto/proveedor ya
/// elegido) para una grabación transcrita.
class ObtenerBorradorCotizacionUseCase {
  final CotizacionRepository _repo;
  ObtenerBorradorCotizacionUseCase(this._repo);

  Future<BorradorCotizacionEntity> call(int grabacionId) =>
      _repo.borrador(grabacionId);
}
