import '../entities/cotizacion_pdf_entity.dart';
import '../repositories/cotizacion_repository.dart';

/// Lee las cotizaciones/PDFs guardadas en la base local del teléfono, sin red.
/// Permite pintar "Mis Cotizaciones" al instante (sin spinner) y refrescar
/// contra el back-end en segundo plano.
class ListarCotizacionesPdfLocalesUseCase {
  final CotizacionRepository _repo;
  ListarCotizacionesPdfLocalesUseCase(this._repo);

  Future<List<CotizacionPdfEntity>> call() => _repo.listarPdfsLocales();
}
