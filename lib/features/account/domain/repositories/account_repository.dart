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

  Future<PaypalSubscriptionIntentoEntity> crearSuscripcionPaypal({
    required String planKey,
  });
  Future<void> cancelarSuscripcionPaypal({required String subscriptionId});
}
