import 'dart:typed_data';

import '../repositories/cotizacion_repository.dart';

/// Descarga los bytes del PDF de una cotización desde su enlace real, para
/// guardar/compartir en el dispositivo.
class DescargarPdfBytesUseCase {
  final CotizacionRepository _repo;
  DescargarPdfBytesUseCase(this._repo);

  Future<Uint8List> call(int cotizacionId) => _repo.pdfBytes(cotizacionId);
}
