// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$processingHash() => r'0c3d64d82a4de0ed83fed10558ffdcce5a4e7144';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Processing
    extends BuildlessAutoDisposeNotifier<ProcessingState> {
  late final int grabacionId;

  ProcessingState build(
    int grabacionId,
  );
}

/// Notifier `.family` (parametrizado por `grabacionId`) que sondea
/// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
/// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
/// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
///
/// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
/// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.
///
/// Copied from [Processing].
@ProviderFor(Processing)
const processingProvider = ProcessingFamily();

/// Notifier `.family` (parametrizado por `grabacionId`) que sondea
/// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
/// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
/// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
///
/// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
/// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.
///
/// Copied from [Processing].
class ProcessingFamily extends Family<ProcessingState> {
  /// Notifier `.family` (parametrizado por `grabacionId`) que sondea
  /// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
  /// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
  /// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
  ///
  /// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
  /// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.
  ///
  /// Copied from [Processing].
  const ProcessingFamily();

  /// Notifier `.family` (parametrizado por `grabacionId`) que sondea
  /// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
  /// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
  /// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
  ///
  /// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
  /// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.
  ///
  /// Copied from [Processing].
  ProcessingProvider call(
    int grabacionId,
  ) {
    return ProcessingProvider(
      grabacionId,
    );
  }

  @override
  ProcessingProvider getProviderOverride(
    covariant ProcessingProvider provider,
  ) {
    return call(
      provider.grabacionId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'processingProvider';
}

/// Notifier `.family` (parametrizado por `grabacionId`) que sondea
/// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
/// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
/// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
///
/// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
/// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.
///
/// Copied from [Processing].
class ProcessingProvider
    extends AutoDisposeNotifierProviderImpl<Processing, ProcessingState> {
  /// Notifier `.family` (parametrizado por `grabacionId`) que sondea
  /// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
  /// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
  /// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
  ///
  /// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
  /// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.
  ///
  /// Copied from [Processing].
  ProcessingProvider(
    int grabacionId,
  ) : this._internal(
          () => Processing()..grabacionId = grabacionId,
          from: processingProvider,
          name: r'processingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$processingHash,
          dependencies: ProcessingFamily._dependencies,
          allTransitiveDependencies:
              ProcessingFamily._allTransitiveDependencies,
          grabacionId: grabacionId,
        );

  ProcessingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.grabacionId,
  }) : super.internal();

  final int grabacionId;

  @override
  ProcessingState runNotifierBuild(
    covariant Processing notifier,
  ) {
    return notifier.build(
      grabacionId,
    );
  }

  @override
  Override overrideWith(Processing Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProcessingProvider._internal(
        () => create()..grabacionId = grabacionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        grabacionId: grabacionId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Processing, ProcessingState>
      createElement() {
    return _ProcessingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProcessingProvider && other.grabacionId == grabacionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, grabacionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProcessingRef on AutoDisposeNotifierProviderRef<ProcessingState> {
  /// The parameter `grabacionId` of this provider.
  int get grabacionId;
}

class _ProcessingProviderElement
    extends AutoDisposeNotifierProviderElement<Processing, ProcessingState>
    with ProcessingRef {
  _ProcessingProviderElement(super.provider);

  @override
  int get grabacionId => (origin as ProcessingProvider).grabacionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
