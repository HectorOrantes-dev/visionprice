/// Resultado de crear una suscripción de PayPal (`POST .../paypal/subscriptions`):
/// todavía no hay cobro confirmado, solo la URL a la que hay que mandar al
/// usuario para que apruebe el pago en la interfaz de PayPal.
class PaypalSubscriptionIntentoEntity {
  final String approvalUrl;
  final String subscriptionId;

  const PaypalSubscriptionIntentoEntity({
    required this.approvalUrl,
    required this.subscriptionId,
  });

  factory PaypalSubscriptionIntentoEntity.fromJson(Map<String, dynamic> json) {
    final sub = json['subscription'];
    final subscriptionId = sub is Map
        ? (sub['id'] ?? sub['subscription_id'] ?? '').toString()
        : (json['subscription_id'] ?? '').toString();
    return PaypalSubscriptionIntentoEntity(
      approvalUrl: (json['approval_url'] ?? '').toString(),
      subscriptionId: subscriptionId,
    );
  }
}
