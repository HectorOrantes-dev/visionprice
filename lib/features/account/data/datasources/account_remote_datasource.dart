import '../../domain/entities/paypal_subscription_intento_entity.dart';
import '../../domain/entities/subscription_entity.dart';

abstract class AccountRemoteDataSource {
  Future<List<SubscriptionEntity>> subscriptions();

  // --- Conekta (tarjeta) ---
  Future<void> crearSuscripcionConekta({
    required String planKey,
    required String cardToken,
  });
  Future<void> cancelarSuscripcionConekta();
  Future<void> eliminarMetodoPagoConekta();

  // --- PayPal ---
  Future<PaypalSubscriptionIntentoEntity> crearSuscripcionPaypal({
    required String planKey,
  });
  Future<void> cancelarSuscripcionPaypal({required String subscriptionId});
}
