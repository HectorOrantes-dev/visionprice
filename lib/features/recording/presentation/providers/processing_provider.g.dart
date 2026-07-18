// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier `.family` (parametrizado por `grabacionId`) que sondea
/// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
/// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
/// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
///
/// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
/// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.

@ProviderFor(Processing)
final processingProvider = ProcessingFamily._();

/// Notifier `.family` (parametrizado por `grabacionId`) que sondea
/// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
/// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
/// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
///
/// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
/// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.
final class ProcessingProvider
    extends $NotifierProvider<Processing, ProcessingState> {
  /// Notifier `.family` (parametrizado por `grabacionId`) que sondea
  /// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
  /// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
  /// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
  ///
  /// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
  /// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.
  ProcessingProvider._(
      {required ProcessingFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'processingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$processingHash();

  @override
  String toString() {
    return r'processingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Processing create() => Processing();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProcessingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProcessingState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProcessingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$processingHash() => r'16802d658bee08691b2968a49c733206a684feb2';

/// Notifier `.family` (parametrizado por `grabacionId`) que sondea
/// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
/// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
/// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
///
/// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
/// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.

final class ProcessingFamily extends $Family
    with
        $ClassFamilyOverride<Processing, ProcessingState, ProcessingState,
            ProcessingState, int> {
  ProcessingFamily._()
      : super(
          retry: null,
          name: r'processingProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Notifier `.family` (parametrizado por `grabacionId`) que sondea
  /// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
  /// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
  /// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
  ///
  /// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
  /// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.

  ProcessingProvider call(
    int grabacionId,
  ) =>
      ProcessingProvider._(argument: grabacionId, from: this);

  @override
  String toString() => r'processingProvider';
}

/// Notifier `.family` (parametrizado por `grabacionId`) que sondea
/// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
/// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
/// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
///
/// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
/// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.

abstract class _$Processing extends $Notifier<ProcessingState> {
  late final _$args = ref.$arg as int;
  int get grabacionId => _$args;

  ProcessingState build(
    int grabacionId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProcessingState, ProcessingState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ProcessingState, ProcessingState>,
        ProcessingState,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
