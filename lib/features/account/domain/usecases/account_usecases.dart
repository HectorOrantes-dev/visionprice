import '../entities/conekta_checkout_entity.dart';
import '../entities/paypal_subscription_intento_entity.dart';
import '../entities/subscription_entity.dart';
import '../repositories/account_repository.dart';

class ObtenerSuscripcionesUseCase {
  final AccountRepository _repo;
  ObtenerSuscripcionesUseCase(this._repo);

  Future<List<SubscriptionEntity>> call() => _repo.subscriptions();
}

/// Crea la suscripción de Conekta: el cobro se confirma en este mismo
/// request (sin webview adicional) usando el `card_token` ya tokenizado.
class CrearSuscripcionConektaUseCase {
  final AccountRepository _repo;
  CrearSuscripcionConektaUseCase(this._repo);

  Future<void> call({required String planKey, required String cardToken}) =>
      _repo.crearSuscripcionConekta(planKey: planKey, cardToken: cardToken);
}

class CancelarSuscripcionConektaUseCase {
  final AccountRepository _repo;
  CancelarSuscripcionConektaUseCase(this._repo);

  Future<void> call() => _repo.cancelarSuscripcionConekta();
}

class EliminarMetodoPagoConektaUseCase {
  final AccountRepository _repo;
  EliminarMetodoPagoConektaUseCase(this._repo);

  Future<void> call() => _repo.eliminarMetodoPagoConekta();
}

/// Crea un checkout hospedado de Conekta (efectivo/OXXO o transferencia/SPEI):
/// no cobra en el request, devuelve la URL del checkout para abrir en un
/// WebView. El pago se confirma después, vía webhook.
class CrearCheckoutConektaUseCase {
  final AccountRepository _repo;
  CrearCheckoutConektaUseCase(this._repo);

  Future<ConektaCheckoutEntity> call({
    required String planKey,
    required List<String> allowedPaymentMethods,
  }) =>
      _repo.crearCheckoutConekta(
        planKey: planKey,
        allowedPaymentMethods: allowedPaymentMethods,
      );
}

/// Crea el intento de suscripción de PayPal: todavía sin cobrar, devuelve la
/// URL de aprobación a la que hay que mandar al usuario.
class CrearSuscripcionPaypalUseCase {
  final AccountRepository _repo;
  CrearSuscripcionPaypalUseCase(this._repo);

  Future<PaypalSubscriptionIntentoEntity> call({required String planKey}) =>
      _repo.crearSuscripcionPaypal(planKey: planKey);
}

class CancelarSuscripcionPaypalUseCase {
  final AccountRepository _repo;
  CancelarSuscripcionPaypalUseCase(this._repo);

  Future<void> call({required String subscriptionId}) =>
      _repo.cancelarSuscripcionPaypal(subscriptionId: subscriptionId);
}
