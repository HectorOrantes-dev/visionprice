import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import 'budget_providers.dart';
import 'export_pdf_state.dart';

export 'export_pdf_state.dart';

part 'export_pdf_provider.g.dart';

/// Notifier de "Exportar PDF" (Riverpod moderno). Pide el PDF de la cotización;
/// el back-end responde JSON y se busca defensivamente un enlace de descarga.
@riverpod
class ExportPdf extends _$ExportPdf {
  @override
  ExportPdfState build() => const ExportPdfState();

  Future<void> descargar(int cotizacionId) async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final data = await ref.read(obtenerPdfUseCaseProvider)(cotizacionId);
      state = state.copyWith(
        loading: false,
        raw: data,
        pdfUrl: (data['url'] ??
                data['pdf_url'] ??
                data['download_url'] ??
                data['link'])
            ?.toString(),
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage:
            e is ApiException ? e.message : 'No se pudo generar el PDF.',
      );
    }
  }
}
