import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/subscription_entity.dart';
import '../widgets/payment_method.dart';
import 'account_providers.dart';

part 'payment_method_provider.g.dart';

/// Estado inmutable de la pantalla "Método de Pago".
class PaymentMethodState {
  final bool loading;
  final String? errorMessage;
  final SubscriptionEntity? subscription;
  final PaymentMethod selected;
  final String? confirmMessage;

  const PaymentMethodState({
    this.loading = true,
    this.errorMessage,
    this.subscription,
    this.selected = PaymentMethod.conekta,
    this.confirmMessage,
  });

  static const _keep = Object();

  PaymentMethodState copyWith({
    bool? loading,
    Object? errorMessage = _keep,
    Object? subscription = _keep,
    PaymentMethod? selected,
    Object? confirmMessage = _keep,
  }) {
    return PaymentMethodState(
      loading: loading ?? this.loading,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      subscription: subscription == _keep
          ? this.subscription
          : subscription as SubscriptionEntity?,
      selected: selected ?? this.selected,
      confirmMessage: confirmMessage == _keep
          ? this.confirmMessage
          : confirmMessage as String?,
    );
  }
}

/// Notifier de "Método de Pago". Carga la suscripción activa para el resumen y
/// gestiona el método seleccionado. Reemplaza al `PaymentMethodViewModel`.
@riverpod
class PaymentMethodNotifier extends _$PaymentMethodNotifier {
  @override
  PaymentMethodState build() {
    load();
    return const PaymentMethodState();
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final subs = await ref.read(obtenerSuscripcionesUseCaseProvider)();
      final activa = subs.where((s) => s.activa);
      state = state.copyWith(
        loading: false,
        subscription: activa.isNotEmpty
            ? activa.first
            : (subs.isNotEmpty ? subs.first : null),
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage:
            e is ApiException ? e.message : 'No se pudo cargar la suscripción.',
      );
    }
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
