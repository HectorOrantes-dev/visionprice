import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../../auth/presentation/providers/perfil_provider.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../domain/entities/subscription_entity.dart';
import '../widgets/payment_method.dart';
import 'account_providers.dart';
import 'subscriptions_provider.dart';

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
      // OJO: NO caer de vuelta a `subs.first` cuando no hay ninguna activa —
      // `GET /subscriptions` es el historial completo, así que eso mostraba
      // la última suscripción CANCELADA en la tarjeta de resumen como si
      // siguiera vigente (plan y precio, sin ningún aviso de "cancelada").
      return activa.isEmpty ? null : activa.first;
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
      _refrescarEstadoDePlan();
      state = state.copyWith(
        procesando: false,
        exitoso: true,
        confirmMessage: '¡Listo! Tu suscripción está activa.',
      );
    } catch (e) {
      // Reintentar tras un timeout (que sí se procesó del lado del
      // servidor) hace que Pagos rechace un segundo `subscribe()` con 400
      // "ya tiene una suscripción activa". Eso NO es un fallo real: la
      // suscripción del primer intento sí quedó — se resincroniza el estado
      // real en vez de dejar al usuario reintentando a ciegas.
      final yaSuscrito = e is ApiException &&
          e.message.toLowerCase().contains('ya tiene una suscripción activa');
      await load();
      if (yaSuscrito) {
        _refrescarEstadoDePlan();
        state = state.copyWith(
          procesando: false,
          exitoso: true,
          confirmMessage: 'Ya tenías una suscripción activa — todo en orden.',
        );
        return;
      }
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
    _refrescarEstadoDePlan();
    state = state.copyWith(
      exitoso: true,
      confirmMessage:
          'Aprobaste el pago en PayPal. Puede tardar unos segundos en activarse.',
    );
  }

  /// Tras confirmar un pago, el "Plan" del perfil, el banner de cuota gratis
  /// y "Mis suscripciones" quedan con datos viejos (cada uno es un provider
  /// separado que no se entera solo) — se refrescan para la próxima vez que
  /// se muestren.
  ///
  /// OJO: `perfilProvider` NO se puede refrescar con `ref.invalidate` —
  /// `AuthRepositoryImpl.getPerfil` cachea el perfil en memoria y solo la
  /// ignora con `forceRefresh: true` (que solo manda `Perfil.refresh()`);
  /// invalidar el provider solo vuelve a llamar a `build()` con el default
  /// `forceRefresh: false`, que devuelve el mismo perfil viejo cacheado.
  void _refrescarEstadoDePlan() {
    ref.read(perfilProvider.notifier).refresh();
    ref.invalidate(usoCotizacionesProvider);
    ref.invalidate(subscriptionsProvider);
  }
}
