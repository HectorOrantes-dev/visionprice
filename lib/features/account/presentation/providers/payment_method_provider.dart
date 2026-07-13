import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/subscription_entity.dart';
import '../widgets/payment_method.dart';
import 'account_providers.dart';

part 'payment_method_provider.g.dart';

/// Estado de la pantalla "Método de Pago". Mezcla datos async (la suscripción
/// del resumen, como `AsyncValue`) con estado interactivo (el método
/// seleccionado y el mensaje de confirmación), por eso se mantiene como
/// `Notifier` y no como `AsyncNotifier`.
class PaymentMethodState {
  final AsyncValue<SubscriptionEntity?> subscription;
  final PaymentMethod selected;
  final String? confirmMessage;

  const PaymentMethodState({
    this.subscription = const AsyncLoading(),
    this.selected = PaymentMethod.conekta,
    this.confirmMessage,
  });

  static const _keep = Object();

  PaymentMethodState copyWith({
    AsyncValue<SubscriptionEntity?>? subscription,
    PaymentMethod? selected,
    Object? confirmMessage = _keep,
  }) {
    return PaymentMethodState(
      subscription: subscription ?? this.subscription,
      selected: selected ?? this.selected,
      confirmMessage: confirmMessage == _keep
          ? this.confirmMessage
          : confirmMessage as String?,
    );
  }
}

/// Notifier de "Método de Pago". Carga la suscripción activa para el resumen
/// (envuelta en `AsyncValue` con `guard`) y gestiona el método seleccionado.
@riverpod
class PaymentMethodNotifier extends _$PaymentMethodNotifier {
  @override
  PaymentMethodState build() {
    // `load` arranca con un `await` (no muta `state` de forma síncrona), así
    // que puede llamarse directo en build sin el hack de `Future.microtask`.
    load();
    return const PaymentMethodState();
  }

  Future<void> load() async {
    final resultado = await AsyncValue.guard<SubscriptionEntity?>(() async {
      final subs = await ref.read(obtenerSuscripcionesUseCaseProvider)();
      final activa = subs.where((s) => s.activa);
      if (activa.isNotEmpty) return activa.first;
      return subs.isNotEmpty ? subs.first : null;
    });
    state = state.copyWith(subscription: resultado);
  }

  void seleccionar(PaymentMethod method) {
    if (state.selected == method) return;
    state = state.copyWith(selected: method, confirmMessage: null);
  }

  /// Confirma el pago. TODO(back-end): cuando exista el endpoint de checkout
  /// (micro de Pagos / Conekta), aquí se iniciaría el cobro con [selected].
  Future<void> confirmar() async {
    state = state.copyWith(
      confirmMessage:
          'Pago aún no disponible: falta el endpoint de checkout en el back-end.',
    );
  }
}
