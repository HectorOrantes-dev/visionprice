// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cotizacion_wizard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
/// elegir material (simple/kit) → resumen → cotización". Sobrevive la
/// navegación entre las pantallas del wizard porque las rutas van con
/// `Navigator.push` (las de abajo del stack siguen montadas y observando el
/// provider), igual que `Parameters` en parameters_provider.dart.

@ProviderFor(CotizacionWizard)
final cotizacionWizardProvider = CotizacionWizardFamily._();

/// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
/// elegir material (simple/kit) → resumen → cotización". Sobrevive la
/// navegación entre las pantallas del wizard porque las rutas van con
/// `Navigator.push` (las de abajo del stack siguen montadas y observando el
/// provider), igual que `Parameters` en parameters_provider.dart.
final class CotizacionWizardProvider
    extends $NotifierProvider<CotizacionWizard, CotizacionWizardState> {
  /// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
  /// elegir material (simple/kit) → resumen → cotización". Sobrevive la
  /// navegación entre las pantallas del wizard porque las rutas van con
  /// `Navigator.push` (las de abajo del stack siguen montadas y observando el
  /// provider), igual que `Parameters` en parameters_provider.dart.
  CotizacionWizardProvider._(
      {required CotizacionWizardFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'cotizacionWizardProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cotizacionWizardHash();

  @override
  String toString() {
    return r'cotizacionWizardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CotizacionWizard create() => CotizacionWizard();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CotizacionWizardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CotizacionWizardState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CotizacionWizardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cotizacionWizardHash() => r'4c69780144fa54c4f32975b8dd2eca31e3adc357';

/// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
/// elegir material (simple/kit) → resumen → cotización". Sobrevive la
/// navegación entre las pantallas del wizard porque las rutas van con
/// `Navigator.push` (las de abajo del stack siguen montadas y observando el
/// provider), igual que `Parameters` en parameters_provider.dart.

final class CotizacionWizardFamily extends $Family
    with
        $ClassFamilyOverride<CotizacionWizard, CotizacionWizardState,
            CotizacionWizardState, CotizacionWizardState, int> {
  CotizacionWizardFamily._()
      : super(
          retry: null,
          name: r'cotizacionWizardProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
  /// elegir material (simple/kit) → resumen → cotización". Sobrevive la
  /// navegación entre las pantallas del wizard porque las rutas van con
  /// `Navigator.push` (las de abajo del stack siguen montadas y observando el
  /// provider), igual que `Parameters` en parameters_provider.dart.

  CotizacionWizardProvider call(
    int proyectoId,
  ) =>
      CotizacionWizardProvider._(argument: proyectoId, from: this);

  @override
  String toString() => r'cotizacionWizardProvider';
}

/// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
/// elegir material (simple/kit) → resumen → cotización". Sobrevive la
/// navegación entre las pantallas del wizard porque las rutas van con
/// `Navigator.push` (las de abajo del stack siguen montadas y observando el
/// provider), igual que `Parameters` en parameters_provider.dart.

abstract class _$CotizacionWizard extends $Notifier<CotizacionWizardState> {
  late final _$args = ref.$arg as int;
  int get proyectoId => _$args;

  CotizacionWizardState build(
    int proyectoId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CotizacionWizardState, CotizacionWizardState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<CotizacionWizardState, CotizacionWizardState>,
        CotizacionWizardState,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
