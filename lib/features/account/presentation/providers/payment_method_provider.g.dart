// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier de "Método de Pago", uno por `planKey` (el plan que se está por
/// contratar). Carga la suscripción activa para el resumen (envuelta en
/// `AsyncValue` con `guard`), gestiona el método seleccionado y dispara la
/// creación de la suscripción real contra Conekta/PayPal.
///
/// La navegación (abrir el WebView de tarjeta o el de aprobación de PayPal)
/// vive en [PaymentMethodScreen], no aquí: un Notifier no tiene `BuildContext`
/// para empujar pantallas.

@ProviderFor(PaymentMethodNotifier)
final paymentMethodProvider = PaymentMethodNotifierFamily._();

/// Notifier de "Método de Pago", uno por `planKey` (el plan que se está por
/// contratar). Carga la suscripción activa para el resumen (envuelta en
/// `AsyncValue` con `guard`), gestiona el método seleccionado y dispara la
/// creación de la suscripción real contra Conekta/PayPal.
///
/// La navegación (abrir el WebView de tarjeta o el de aprobación de PayPal)
/// vive en [PaymentMethodScreen], no aquí: un Notifier no tiene `BuildContext`
/// para empujar pantallas.
final class PaymentMethodNotifierProvider
    extends $NotifierProvider<PaymentMethodNotifier, PaymentMethodState> {
  /// Notifier de "Método de Pago", uno por `planKey` (el plan que se está por
  /// contratar). Carga la suscripción activa para el resumen (envuelta en
  /// `AsyncValue` con `guard`), gestiona el método seleccionado y dispara la
  /// creación de la suscripción real contra Conekta/PayPal.
  ///
  /// La navegación (abrir el WebView de tarjeta o el de aprobación de PayPal)
  /// vive en [PaymentMethodScreen], no aquí: un Notifier no tiene `BuildContext`
  /// para empujar pantallas.
  PaymentMethodNotifierProvider._(
      {required PaymentMethodNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'paymentMethodProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$paymentMethodNotifierHash();

  @override
  String toString() {
    return r'paymentMethodProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is PaymentMethodNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paymentMethodNotifierHash() =>
    r'20cc0c3163ef185e98b84046d1af2dde1ef1bb68';

/// Notifier de "Método de Pago", uno por `planKey` (el plan que se está por
/// contratar). Carga la suscripción activa para el resumen (envuelta en
/// `AsyncValue` con `guard`), gestiona el método seleccionado y dispara la
/// creación de la suscripción real contra Conekta/PayPal.
///
/// La navegación (abrir el WebView de tarjeta o el de aprobación de PayPal)
/// vive en [PaymentMethodScreen], no aquí: un Notifier no tiene `BuildContext`
/// para empujar pantallas.

final class PaymentMethodNotifierFamily extends $Family
    with
        $ClassFamilyOverride<PaymentMethodNotifier, PaymentMethodState,
            PaymentMethodState, PaymentMethodState, String> {
  PaymentMethodNotifierFamily._()
      : super(
          retry: null,
          name: r'paymentMethodProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Notifier de "Método de Pago", uno por `planKey` (el plan que se está por
  /// contratar). Carga la suscripción activa para el resumen (envuelta en
  /// `AsyncValue` con `guard`), gestiona el método seleccionado y dispara la
  /// creación de la suscripción real contra Conekta/PayPal.
  ///
  /// La navegación (abrir el WebView de tarjeta o el de aprobación de PayPal)
  /// vive en [PaymentMethodScreen], no aquí: un Notifier no tiene `BuildContext`
  /// para empujar pantallas.

  PaymentMethodNotifierProvider call(
    String planKey,
  ) =>
      PaymentMethodNotifierProvider._(argument: planKey, from: this);

  @override
  String toString() => r'paymentMethodProvider';
}

/// Notifier de "Método de Pago", uno por `planKey` (el plan que se está por
/// contratar). Carga la suscripción activa para el resumen (envuelta en
/// `AsyncValue` con `guard`), gestiona el método seleccionado y dispara la
/// creación de la suscripción real contra Conekta/PayPal.
///
/// La navegación (abrir el WebView de tarjeta o el de aprobación de PayPal)
/// vive en [PaymentMethodScreen], no aquí: un Notifier no tiene `BuildContext`
/// para empujar pantallas.

abstract class _$PaymentMethodNotifier extends $Notifier<PaymentMethodState> {
  late final _$args = ref.$arg as String;
  String get planKey => _$args;

  PaymentMethodState build(
    String planKey,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PaymentMethodState, PaymentMethodState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PaymentMethodState, PaymentMethodState>,
        PaymentMethodState,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
