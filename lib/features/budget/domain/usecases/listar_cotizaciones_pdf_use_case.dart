import '../entities/cotizacion_pdf_entity.dart';
import '../repositories/cotizacion_repository.dart';

/// Lista todas las cotizaciones/PDFs del usuario autenticado, en todas sus obras
/// (`GET /api/v1/cotizaciones/pdfs`).
class ListarCotizacionesPdfUseCase {
  final CotizacionRepository _repo;
  ListarCotizacionesPdfUseCase(this._repo);

  Future<List<CotizacionPdfEntity>> call() => _repo.listarPdfs();
}
