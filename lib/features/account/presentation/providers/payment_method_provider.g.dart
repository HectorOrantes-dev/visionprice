// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier de "Método de Pago". Carga la suscripción activa para el resumen
/// (envuelta en `AsyncValue` con `guard`) y gestiona el método seleccionado.

@ProviderFor(PaymentMethodNotifier)
final paymentMethodProvider = PaymentMethodNotifierProvider._();

/// Notifier de "Método de Pago". Carga la suscripción activa para el resumen
/// (envuelta en `AsyncValue` con `guard`) y gestiona el método seleccionado.
final class PaymentMethodNotifierProvider
    extends $NotifierProvider<PaymentMethodNotifier, PaymentMethodState> {
  /// Notifier de "Método de Pago". Carga la suscripción activa para el resumen
  /// (envuelta en `AsyncValue` con `guard`) y gestiona el método seleccionado.
  PaymentMethodNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'paymentMethodProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$paymentMethodNotifierHash();

  @$internal
  @override
  PaymentMethodNotifier create() => PaymentMethodNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentMethodState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentMethodState>(value),
    );
  }
}

String _$paymentMethodNotifierHash() =>
    r'57db002eee70589a73d7e73978e681c65d950806';

/// Notifier de "Método de Pago". Carga la suscripción activa para el resumen
/// (envuelta en `AsyncValue` con `guard`) y gestiona el método seleccionado.

abstract class _$PaymentMethodNotifier extends $Notifier<PaymentMethodState> {
  PaymentMethodState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PaymentMethodState, PaymentMethodState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PaymentMethodState, PaymentMethodState>,
        PaymentMethodState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
