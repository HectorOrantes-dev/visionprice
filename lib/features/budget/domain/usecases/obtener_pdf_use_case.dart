
import '../repositories/cotizacion_repository.dart';

/// Obtiene el PDF de una cotización.
class ObtenerPdfUseCase {
  final CotizacionRepository _repo;
  ObtenerPdfUseCase(this._repo);

  Future<Map<String, dynamic>> call(int cotizacionId) =>
      _repo.pdf(cotizacionId);
}
