import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/subscription_entity.dart';
import '../widgets/payment_method.dart';
import 'account_providers.dart';

part 'payment_method_provider.g.dart';

const _conektaMetodoAllowedMethods = {
  ConektaMetodo.efectivo: ['cash'],
  ConektaMetodo.transferencia: ['bank_transfer'],
};

/// Estado de la pantalla "Método de Pago". Mezcla datos async (la suscripción
/// del resumen, como `AsyncValue`) con estado interactivo (el sub-método de
/// Conekta y el mensaje de confirmación), por eso se mantiene como
/// `Notifier` y no como `AsyncNotifier`. El método (Conekta/PayPal) en sí ya
/// no vive aquí: lo decide la pantalla que abre esta (ver
/// [PaymentMethodScreen.metodo]).
class PaymentMethodState {
  final AsyncValue<SubscriptionEntity?> subscription;
  final ConektaMetodo conektaMetodo;
  final String? confirmMessage;
  final bool procesando;
  final bool exitoso;

  const PaymentMethodState({
    this.subscription = const AsyncLoading(),
    this.conektaMetodo = ConektaMetodo.tarjeta,
    this.confirmMessage,
    this.procesando = false,
    this.exitoso = false,
  });

  static const _keep = Object();

  PaymentMethodState copyWith({
    AsyncValue<SubscriptionEntity?>? subscription,
    ConektaMetodo? conektaMetodo,
    Object? confirmMessage = _keep,
    bool? procesando,
    bool? exitoso,
  }) {
    return PaymentMethodState(
      subscription: subscription ?? this.subscription,
      conektaMetodo: conektaMetodo ?? this.conektaMetodo,
      confirmMessage: confirmMessage == _keep
          ? this.confirmMessage
          : confirmMessage as String?,
      procesando: procesando ?? this.procesando,
      exitoso: exitoso ?? this.exitoso,
    );
  }
}

/// Notifier de "Método de Pago", uno por `planKey` (el plan que se está por
/// contratar). Carga la suscripción activa para el resumen (envuelta en
/// `AsyncValue` con `guard`), gestiona el método seleccionado y dispara la
/// creación de la suscripción real contra Conekta/PayPal.
///
/// La navegación (abrir el WebView de tarjeta o el de aprobación de PayPal)
/// vive en [PaymentMethodScreen], no aquí: un Notifier no tiene `BuildContext`
/// para empujar pantallas.
@riverpod
class PaymentMethodNotifier extends _$PaymentMethodNotifier {
  @override
  PaymentMethodState build(String planKey) {
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

  void seleccionarConektaMetodo(ConektaMetodo metodo) {
    if (state.conektaMetodo == metodo) return;
    state = state.copyWith(conektaMetodo: metodo, confirmMessage: null);
  }

  /// Conekta: el `card_token` ya viene tokenizado (desde el WebView de
  /// `conekta.js`). El cobro se confirma en este mismo request.
  Future<void> confirmarConekta(String cardToken) async {
    state = state.copyWith(procesando: true, confirmMessage: null);
    try {
      await ref.read(crearSuscripcionConektaUseCaseProvider)(
        planKey: planKey,
        cardToken: cardToken,
      );
      await load();
      state = state.copyWith(
        procesando: false,
        exitoso: true,
        confirmMessage: '¡Listo! Tu suscripción está activa.',
      );
    } catch (e) {
      state = state.copyWith(
        procesando: false,
        confirmMessage:
            e is ApiException ? e.message : 'No se pudo procesar el pago.',
      );
    }
  }

  /// Conekta checkout (efectivo/transferencia): crea la orden hospedada y
  /// devuelve la `checkout_url` para abrirla en un WebView. A diferencia de
  /// tarjeta, NO confirma el pago en este request (llega por webhook).
  Future<String?> iniciarConektaCheckout() async {
    state = state.copyWith(procesando: true, confirmMessage: null);
    try {
      final checkout = await ref.read(crearCheckoutConektaUseCaseProvider)(
        planKey: planKey,
        allowedPaymentMethods:
            _conektaMetodoAllowedMethods[state.conektaMetodo]!,
      );
      state = state.copyWith(procesando: false);
      return checkout.checkoutUrl;
    } catch (e) {
      state = state.copyWith(
        procesando: false,
        confirmMessage:
            e is ApiException ? e.message : 'No se pudo iniciar el pago.',
      );
      return null;
    }
  }

  /// PayPal paso 1: crea el intento de suscripción y devuelve la
  /// `approval_url` para que la UI abra el WebView de aprobación. `null` si
  /// falló (el mensaje ya queda en `confirmMessage`).
  Future<String?> iniciarPaypal() async {
    state = state.copyWith(procesando: true, confirmMessage: null);
    try {
      final intento = await ref.read(crearSuscripcionPaypalUseCaseProvider)(
        planKey: planKey,
      );
      state = state.copyWith(procesando: false);
      return intento.approvalUrl;
    } catch (e) {
      state = state.copyWith(
        procesando: false,
        confirmMessage: e is ApiException
            ? e.message
            : 'No se pudo iniciar el pago con PayPal.',
      );
      return null;
    }
  }

  /// PayPal paso 2: el usuario ya aprobó (o canceló) en el WebView. El `pop`
  /// de PayPal NO confirma el cobro (eso llega por webhook), así que solo se
  /// refresca el estado para reflejar lo que el back-end ya sepa.
  Future<void> finalizarPaypal({required bool aprobado}) async {
    if (!aprobado) {
      state = state.copyWith(confirmMessage: 'Pago cancelado.');
      return;
    }
    await load();
    state = state.copyWith(
      exitoso: true,
      confirmMessage:
          'Aprobaste el pago en PayPal. Puede tardar unos segundos en activarse.',
    );
  }
}
