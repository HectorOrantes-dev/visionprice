// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
/// detalle de la grabación (transcripción + confianza + extracción) y el
/// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).

@ProviderFor(Parameters)
final parametersProvider = ParametersFamily._();

/// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
/// detalle de la grabación (transcripción + confianza + extracción) y el
/// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).
final class ParametersProvider
    extends $NotifierProvider<Parameters, ParametersState> {
  /// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
  /// detalle de la grabación (transcripción + confianza + extracción) y el
  /// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).
  ParametersProvider._(
      {required ParametersFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'parametersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$parametersHash();

  @override
  String toString() {
    return r'parametersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Parameters create() => Parameters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ParametersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ParametersState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ParametersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parametersHash() => r'5985b7b839e413ec684c752cc48092cd36b1d1f0';

/// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
/// detalle de la grabación (transcripción + confianza + extracción) y el
/// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).

final class ParametersFamily extends $Family
    with
        $ClassFamilyOverride<Parameters, ParametersState, ParametersState,
            ParametersState, int> {
  ParametersFamily._()
      : super(
          retry: null,
          name: r'parametersProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
  /// detalle de la grabación (transcripción + confianza + extracción) y el
  /// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).

  ParametersProvider call(
    int grabacionId,
  ) =>
      ParametersProvider._(argument: grabacionId, from: this);

  @override
  String toString() => r'parametersProvider';
}

/// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
/// detalle de la grabación (transcripción + confianza + extracción) y el
/// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).

abstract class _$Parameters extends $Notifier<ParametersState> {
  late final _$args = ref.$arg as int;
  int get grabacionId => _$args;

  ParametersState build(
    int grabacionId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ParametersState, ParametersState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ParametersState, ParametersState>,
        ParametersState,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
