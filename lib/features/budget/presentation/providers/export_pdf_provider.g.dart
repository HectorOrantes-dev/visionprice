// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_pdf_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exportPdfHash() => r'923efad2dc5c083ceee45e84baba53139e2554ae';

/// Notifier de "Exportar PDF" (Riverpod moderno). Pide el PDF de la cotización;
/// el back-end responde JSON y se busca defensivamente un enlace de descarga.
///
/// Copied from [ExportPdf].
@ProviderFor(ExportPdf)
final exportPdfProvider =
    AutoDisposeNotifierProvider<ExportPdf, ExportPdfState>.internal(
  ExportPdf.new,
  name: r'exportPdfProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$exportPdfHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExportPdf = AutoDisposeNotifier<ExportPdfState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
