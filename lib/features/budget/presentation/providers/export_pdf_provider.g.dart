// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_pdf_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier de "Exportar PDF" (Riverpod moderno). Pide el PDF de la cotización;
/// el back-end responde JSON y se busca defensivamente un enlace de descarga.

@ProviderFor(ExportPdf)
final exportPdfProvider = ExportPdfProvider._();

/// Notifier de "Exportar PDF" (Riverpod moderno). Pide el PDF de la cotización;
/// el back-end responde JSON y se busca defensivamente un enlace de descarga.
final class ExportPdfProvider
    extends $NotifierProvider<ExportPdf, ExportPdfState> {
  /// Notifier de "Exportar PDF" (Riverpod moderno). Pide el PDF de la cotización;
  /// el back-end responde JSON y se busca defensivamente un enlace de descarga.
  ExportPdfProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'exportPdfProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$exportPdfHash();

  @$internal
  @override
  ExportPdf create() => ExportPdf();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportPdfState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportPdfState>(value),
    );
  }
}

String _$exportPdfHash() => r'ba5057e47209fc5c1782f34f7c635b3bedc85478';

/// Notifier de "Exportar PDF" (Riverpod moderno). Pide el PDF de la cotización;
/// el back-end responde JSON y se busca defensivamente un enlace de descarga.

abstract class _$ExportPdf extends $Notifier<ExportPdfState> {
  ExportPdfState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ExportPdfState, ExportPdfState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ExportPdfState, ExportPdfState>,
        ExportPdfState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
