/// Estado inmutable de "Exportar PDF".
class ExportPdfState {
  final bool loading;
  final String? errorMessage;
  final String? pdfUrl;
  final Map<String, dynamic>? raw;

  const ExportPdfState({
    this.loading = false,
    this.errorMessage,
    this.pdfUrl,
    this.raw,
  });

  static const _keep = Object();

  ExportPdfState copyWith({
    bool? loading,
    Object? errorMessage = _keep,
    Object? pdfUrl = _keep,
    Object? raw = _keep,
  }) {
    return ExportPdfState(
      loading: loading ?? this.loading,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      pdfUrl: pdfUrl == _keep ? this.pdfUrl : pdfUrl as String?,
      raw: raw == _keep ? this.raw : raw as Map<String, dynamic>?,
    );
  }
}
