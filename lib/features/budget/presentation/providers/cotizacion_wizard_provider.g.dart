// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cotizacion_wizard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cotizacionWizardHash() => r'4c69780144fa54c4f32975b8dd2eca31e3adc357';

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

abstract class _$CotizacionWizard
    extends BuildlessAutoDisposeNotifier<CotizacionWizardState> {
  late final int proyectoId;

  CotizacionWizardState build(
    int proyectoId,
  );
}

/// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
/// elegir material (simple/kit) → resumen → cotización". Sobrevive la
/// navegación entre las pantallas del wizard porque las rutas van con
/// `Navigator.push` (las de abajo del stack siguen montadas y observando el
/// provider), igual que `Parameters` en parameters_provider.dart.
///
/// Copied from [CotizacionWizard].
@ProviderFor(CotizacionWizard)
const cotizacionWizardProvider = CotizacionWizardFamily();

/// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
/// elegir material (simple/kit) → resumen → cotización". Sobrevive la
/// navegación entre las pantallas del wizard porque las rutas van con
/// `Navigator.push` (las de abajo del stack siguen montadas y observando el
/// provider), igual que `Parameters` en parameters_provider.dart.
///
/// Copied from [CotizacionWizard].
class CotizacionWizardFamily extends Family<CotizacionWizardState> {
  /// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
  /// elegir material (simple/kit) → resumen → cotización". Sobrevive la
  /// navegación entre las pantallas del wizard porque las rutas van con
  /// `Navigator.push` (las de abajo del stack siguen montadas y observando el
  /// provider), igual que `Parameters` en parameters_provider.dart.
  ///
  /// Copied from [CotizacionWizard].
  const CotizacionWizardFamily();

  /// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
  /// elegir material (simple/kit) → resumen → cotización". Sobrevive la
  /// navegación entre las pantallas del wizard porque las rutas van con
  /// `Navigator.push` (las de abajo del stack siguen montadas y observando el
  /// provider), igual que `Parameters` en parameters_provider.dart.
  ///
  /// Copied from [CotizacionWizard].
  CotizacionWizardProvider call(
    int proyectoId,
  ) {
    return CotizacionWizardProvider(
      proyectoId,
    );
  }

  @override
  CotizacionWizardProvider getProviderOverride(
    covariant CotizacionWizardProvider provider,
  ) {
    return call(
      provider.proyectoId,
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
  String? get name => r'cotizacionWizardProvider';
}

/// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
/// elegir material (simple/kit) → resumen → cotización". Sobrevive la
/// navegación entre las pantallas del wizard porque las rutas van con
/// `Navigator.push` (las de abajo del stack siguen montadas y observando el
/// provider), igual que `Parameters` en parameters_provider.dart.
///
/// Copied from [CotizacionWizard].
class CotizacionWizardProvider extends AutoDisposeNotifierProviderImpl<
    CotizacionWizard, CotizacionWizardState> {
  /// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
  /// elegir material (simple/kit) → resumen → cotización". Sobrevive la
  /// navegación entre las pantallas del wizard porque las rutas van con
  /// `Navigator.push` (las de abajo del stack siguen montadas y observando el
  /// provider), igual que `Parameters` en parameters_provider.dart.
  ///
  /// Copied from [CotizacionWizard].
  CotizacionWizardProvider(
    int proyectoId,
  ) : this._internal(
          () => CotizacionWizard()..proyectoId = proyectoId,
          from: cotizacionWizardProvider,
          name: r'cotizacionWizardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cotizacionWizardHash,
          dependencies: CotizacionWizardFamily._dependencies,
          allTransitiveDependencies:
              CotizacionWizardFamily._allTransitiveDependencies,
          proyectoId: proyectoId,
        );

  CotizacionWizardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.proyectoId,
  }) : super.internal();

  final int proyectoId;

  @override
  CotizacionWizardState runNotifierBuild(
    covariant CotizacionWizard notifier,
  ) {
    return notifier.build(
      proyectoId,
    );
  }

  @override
  Override overrideWith(CotizacionWizard Function() create) {
    return ProviderOverride(
      origin: this,
      override: CotizacionWizardProvider._internal(
        () => create()..proyectoId = proyectoId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        proyectoId: proyectoId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CotizacionWizard, CotizacionWizardState>
      createElement() {
    return _CotizacionWizardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CotizacionWizardProvider && other.proyectoId == proyectoId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, proyectoId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CotizacionWizardRef
    on AutoDisposeNotifierProviderRef<CotizacionWizardState> {
  /// The parameter `proyectoId` of this provider.
  int get proyectoId;
}

class _CotizacionWizardProviderElement
    extends AutoDisposeNotifierProviderElement<CotizacionWizard,
        CotizacionWizardState> with CotizacionWizardRef {
  _CotizacionWizardProviderElement(super.provider);

  @override
  int get proyectoId => (origin as CotizacionWizardProvider).proyectoId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
