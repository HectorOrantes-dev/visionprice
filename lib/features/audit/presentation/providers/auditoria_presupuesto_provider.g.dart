// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditoria_presupuesto_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auditoría de precios de UN presupuesto/cotización (`presupuestoId` =
/// `CotizacionEntity.id`, mismo id en ambos back-ends).

@ProviderFor(auditoriaPresupuesto)
final auditoriaPresupuestoProvider = AuditoriaPresupuestoFamily._();

/// Auditoría de precios de UN presupuesto/cotización (`presupuestoId` =
/// `CotizacionEntity.id`, mismo id en ambos back-ends).

final class AuditoriaPresupuestoProvider extends $FunctionalProvider<
        AsyncValue<AuditoriaResultadoEntity>,
        AuditoriaResultadoEntity,
        FutureOr<AuditoriaResultadoEntity>>
    with
        $FutureModifier<AuditoriaResultadoEntity>,
        $FutureProvider<AuditoriaResultadoEntity> {
  /// Auditoría de precios de UN presupuesto/cotización (`presupuestoId` =
  /// `CotizacionEntity.id`, mismo id en ambos back-ends).
  AuditoriaPresupuestoProvider._(
      {required AuditoriaPresupuestoFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'auditoriaPresupuestoProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$auditoriaPresupuestoHash();

  @override
  String toString() {
    return r'auditoriaPresupuestoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AuditoriaResultadoEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuditoriaResultadoEntity> create(Ref ref) {
    final argument = this.argument as int;
    return auditoriaPresupuesto(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AuditoriaPresupuestoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$auditoriaPresupuestoHash() =>
    r'e01cec13e2762824f9cde1866b129f5e25873de5';

/// Auditoría de precios de UN presupuesto/cotización (`presupuestoId` =
/// `CotizacionEntity.id`, mismo id en ambos back-ends).

final class AuditoriaPresupuestoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AuditoriaResultadoEntity>, int> {
  AuditoriaPresupuestoFamily._()
      : super(
          retry: null,
          name: r'auditoriaPresupuestoProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Auditoría de precios de UN presupuesto/cotización (`presupuestoId` =
  /// `CotizacionEntity.id`, mismo id en ambos back-ends).

  AuditoriaPresupuestoProvider call(
    int presupuestoId,
  ) =>
      AuditoriaPresupuestoProvider._(argument: presupuestoId, from: this);

  @override
  String toString() => r'auditoriaPresupuestoProvider';
}
