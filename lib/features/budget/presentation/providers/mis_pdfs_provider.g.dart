// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mis_pdfs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AsyncNotifier de "Mis Cotizaciones" (`GET /api/v1/cotizaciones/pdfs`).
///
/// Estrategia **cache-first**: si la base local del teléfono ya tiene el
/// listado, se devuelve de inmediato (la UI NO muestra spinner) y el back-end se
/// consulta en segundo plano para actualizar. El `AsyncLoading` solo aparece la
/// primera vez, cuando todavía no hay nada cacheado.

@ProviderFor(MisPdfs)
final misPdfsProvider = MisPdfsProvider._();

/// AsyncNotifier de "Mis Cotizaciones" (`GET /api/v1/cotizaciones/pdfs`).
///
/// Estrategia **cache-first**: si la base local del teléfono ya tiene el
/// listado, se devuelve de inmediato (la UI NO muestra spinner) y el back-end se
/// consulta en segundo plano para actualizar. El `AsyncLoading` solo aparece la
/// primera vez, cuando todavía no hay nada cacheado.
final class MisPdfsProvider
    extends $AsyncNotifierProvider<MisPdfs, List<CotizacionPdfEntity>> {
  /// AsyncNotifier de "Mis Cotizaciones" (`GET /api/v1/cotizaciones/pdfs`).
  ///
  /// Estrategia **cache-first**: si la base local del teléfono ya tiene el
  /// listado, se devuelve de inmediato (la UI NO muestra spinner) y el back-end se
  /// consulta en segundo plano para actualizar. El `AsyncLoading` solo aparece la
  /// primera vez, cuando todavía no hay nada cacheado.
  MisPdfsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'misPdfsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$misPdfsHash();

  @$internal
  @override
  MisPdfs create() => MisPdfs();
}

String _$misPdfsHash() => r'bd1060e4a573b231850dc647a76312ca5657eb57';

/// AsyncNotifier de "Mis Cotizaciones" (`GET /api/v1/cotizaciones/pdfs`).
///
/// Estrategia **cache-first**: si la base local del teléfono ya tiene el
/// listado, se devuelve de inmediato (la UI NO muestra spinner) y el back-end se
/// consulta en segundo plano para actualizar. El `AsyncLoading` solo aparece la
/// primera vez, cuando todavía no hay nada cacheado.

abstract class _$MisPdfs extends $AsyncNotifier<List<CotizacionPdfEntity>> {
  FutureOr<List<CotizacionPdfEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<CotizacionPdfEntity>>,
        List<CotizacionPdfEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<CotizacionPdfEntity>>,
            List<CotizacionPdfEntity>>,
        AsyncValue<List<CotizacionPdfEntity>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
