// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentMethodNotifierHash() =>
    r'cc5656f7ef72dc35d92b0638314ab8af8ad74505';

/// Notifier de "Método de Pago". Carga la suscripción activa para el resumen y
/// gestiona el método seleccionado. Reemplaza al `PaymentMethodViewModel`.
///
/// Copied from [PaymentMethodNotifier].
@ProviderFor(PaymentMethodNotifier)
final paymentMethodNotifierProvider = AutoDisposeNotifierProvider<
    PaymentMethodNotifier, PaymentMethodState>.internal(
  PaymentMethodNotifier.new,
  name: r'paymentMethodNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentMethodNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentMethodNotifier = AutoDisposeNotifier<PaymentMethodState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
