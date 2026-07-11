// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$parametersHash() => r'b756164c1384fd4a92f5f254550ff75c74f1d01a';

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

abstract class _$Parameters
    extends BuildlessAutoDisposeNotifier<ParametersState> {
  late final int grabacionId;

  ParametersState build(
    int grabacionId,
  );
}

/// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
/// detalle de la grabación (transcripción + confianza + extracción) y el
/// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).
///
/// Copied from [Parameters].
@ProviderFor(Parameters)
const parametersProvider = ParametersFamily();

/// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
/// detalle de la grabación (transcripción + confianza + extracción) y el
/// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).
///
/// Copied from [Parameters].
class ParametersFamily extends Family<ParametersState> {
  /// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
  /// detalle de la grabación (transcripción + confianza + extracción) y el
  /// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).
  ///
  /// Copied from [Parameters].
  const ParametersFamily();

  /// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
  /// detalle de la grabación (transcripción + confianza + extracción) y el
  /// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).
  ///
  /// Copied from [Parameters].
  ParametersProvider call(
    int grabacionId,
  ) {
    return ParametersProvider(
      grabacionId,
    );
  }

  @override
  ParametersProvider getProviderOverride(
    covariant ParametersProvider provider,
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
  String? get name => r'parametersProvider';
}

/// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
/// detalle de la grabación (transcripción + confianza + extracción) y el
/// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).
///
/// Copied from [Parameters].
class ParametersProvider
    extends AutoDisposeNotifierProviderImpl<Parameters, ParametersState> {
  /// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
  /// detalle de la grabación (transcripción + confianza + extracción) y el
  /// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).
  ///
  /// Copied from [Parameters].
  ParametersProvider(
    int grabacionId,
  ) : this._internal(
          () => Parameters()..grabacionId = grabacionId,
          from: parametersProvider,
          name: r'parametersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$parametersHash,
          dependencies: ParametersFamily._dependencies,
          allTransitiveDependencies:
              ParametersFamily._allTransitiveDependencies,
          grabacionId: grabacionId,
        );

  ParametersProvider._internal(
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
  ParametersState runNotifierBuild(
    covariant Parameters notifier,
  ) {
    return notifier.build(
      grabacionId,
    );
  }

  @override
  Override overrideWith(Parameters Function() create) {
    return ProviderOverride(
      origin: this,
      override: ParametersProvider._internal(
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
  AutoDisposeNotifierProviderElement<Parameters, ParametersState>
      createElement() {
    return _ParametersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ParametersProvider && other.grabacionId == grabacionId;
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
mixin ParametersRef on AutoDisposeNotifierProviderRef<ParametersState> {
  /// The parameter `grabacionId` of this provider.
  int get grabacionId;
}

class _ParametersProviderElement
    extends AutoDisposeNotifierProviderElement<Parameters, ParametersState>
    with ParametersRef {
  _ParametersProviderElement(super.provider);

  @override
  int get grabacionId => (origin as ParametersProvider).grabacionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
