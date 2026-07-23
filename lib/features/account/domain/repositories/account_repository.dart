import '../entities/conekta_checkout_entity.dart';
import '../entities/paypal_subscription_intento_entity.dart';
import '../entities/subscription_entity.dart';

abstract class AccountRepository {
  Future<List<SubscriptionEntity>> subscriptions();

  Future<void> crearSuscripcionConekta({
    required String planKey,
    required String cardToken,
  });
  Future<void> cancelarSuscripcionConekta();
  Future<void> eliminarMetodoPagoConekta();

  /// Checkout hospedado (no recurrente): efectivo (OXXO) o transferencia
  /// (SPEI). `allowedPaymentMethods` es un subconjunto de
  /// `['card','cash','bank_transfer']`.
  Future<ConektaCheckoutEntity> crearCheckoutConekta({
    required String planKey,
    required List<String> allowedPaymentMethods,
  });

  Future<PaypalSubscriptionIntentoEntity> crearSuscripcionPaypal({
    required String planKey,
  });
  Future<void> cancelarSuscripcionPaypal({required String subscriptionId});
}
