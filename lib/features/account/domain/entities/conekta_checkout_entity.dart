/// Orden de checkout hospedado de Conekta (`POST/GET .../conekta/checkout`):
/// pago no recurrente por tarjeta, OXXO (efectivo) o SPEI (transferencia).
/// El usuario paga en [checkoutUrl]; la confirmación llega después por
/// webhook (`status` pasa a `paid`), no en este mismo request.
class ConektaCheckoutEntity {
  final String id;
  final String checkoutUrl;
  final String status;

  const ConektaCheckoutEntity({
    required this.id,
    required this.checkoutUrl,
    required this.status,
  });

  factory ConektaCheckoutEntity.fromJson(Map<String, dynamic> json) {
    return ConektaCheckoutEntity(
      id: (json['id'] ?? '').toString(),
      checkoutUrl: (json['checkout_url'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }
}
