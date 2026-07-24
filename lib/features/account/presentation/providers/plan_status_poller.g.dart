// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_status_poller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Mientras alguna pantalla lo observe (Perfil, Mis suscripciones, Método de
/// pago), refresca periódicamente el estado real del plan.
///
/// La activación (webhook de Conekta/PayPal tras pagar) o la confirmación de
/// un pago OXXO/SPEI pueden llegar segundos o minutos después de que el
/// usuario ya está mirando la pantalla, sin que él dispare ninguna acción —
/// sin este sondeo, tendría que cerrar y reabrir la app (o hacer
/// pull-to-refresh) para enterarse. Es `autoDispose`: en cuanto ninguna
/// pantalla lo observa, el temporizador se cancela solo.

@ProviderFor(PlanStatusPoller)
final planStatusPollerProvider = PlanStatusPollerProvider._();

/// Mientras alguna pantalla lo observe (Perfil, Mis suscripciones, Método de
/// pago), refresca periódicamente el estado real del plan.
///
/// La activación (webhook de Conekta/PayPal tras pagar) o la confirmación de
/// un pago OXXO/SPEI pueden llegar segundos o minutos después de que el
/// usuario ya está mirando la pantalla, sin que él dispare ninguna acción —
/// sin este sondeo, tendría que cerrar y reabrir la app (o hacer
/// pull-to-refresh) para enterarse. Es `autoDispose`: en cuanto ninguna
/// pantalla lo observa, el temporizador se cancela solo.
final class PlanStatusPollerProvider
    extends $NotifierProvider<PlanStatusPoller, void> {
  /// Mientras alguna pantalla lo observe (Perfil, Mis suscripciones, Método de
  /// pago), refresca periódicamente el estado real del plan.
  ///
  /// La activación (webhook de Conekta/PayPal tras pagar) o la confirmación de
  /// un pago OXXO/SPEI pueden llegar segundos o minutos después de que el
  /// usuario ya está mirando la pantalla, sin que él dispare ninguna acción —
  /// sin este sondeo, tendría que cerrar y reabrir la app (o hacer
  /// pull-to-refresh) para enterarse. Es `autoDispose`: en cuanto ninguna
  /// pantalla lo observa, el temporizador se cancela solo.
  PlanStatusPollerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'planStatusPollerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$planStatusPollerHash();

  @$internal
  @override
  PlanStatusPoller create() => PlanStatusPoller();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$planStatusPollerHash() => r'f6946885683fd18146394a728de8cc37d342ca99';

/// Mientras alguna pantalla lo observe (Perfil, Mis suscripciones, Método de
/// pago), refresca periódicamente el estado real del plan.
///
/// La activación (webhook de Conekta/PayPal tras pagar) o la confirmación de
/// un pago OXXO/SPEI pueden llegar segundos o minutos después de que el
/// usuario ya está mirando la pantalla, sin que él dispare ninguna acción —
/// sin este sondeo, tendría que cerrar y reabrir la app (o hacer
/// pull-to-refresh) para enterarse. Es `autoDispose`: en cuanto ninguna
/// pantalla lo observa, el temporizador se cancela solo.

abstract class _$PlanStatusPoller extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<void, void>, void, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
