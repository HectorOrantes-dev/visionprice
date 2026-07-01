import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/usecases/cotizacion_usecases.dart';

/// ViewModel de "Exportar PDF": pide el PDF de la cotización. El back-end
/// responde JSON; se busca defensivamente un enlace de descarga.
@injectable
class ExportPdfViewModel extends ChangeNotifier {
  final ObtenerPdfUseCase _obtenerPdf;
  ExportPdfViewModel(this._obtenerPdf);

  bool _loading = false;
  String? _errorMessage;
  String? _pdfUrl;
  Map<String, dynamic>? _raw;

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  String? get pdfUrl => _pdfUrl;
  Map<String, dynamic>? get raw => _raw;

  Future<void> descargar(int cotizacionId) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _obtenerPdf(cotizacionId);
      _raw = data;
      _pdfUrl = (data['url'] ??
              data['pdf_url'] ??
              data['download_url'] ??
              data['link'])
          ?.toString();
    } catch (e) {
      _errorMessage =
          e is ApiException ? e.message : 'No se pudo generar el PDF.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
