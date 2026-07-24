/// Suscripción del usuario (`GET /api/v1/me/subscriptions`). El back-end no
/// fija un esquema estricto, así que se parsea de forma defensiva.
class SubscriptionEntity {
  final String plan;
  final String estado;
  final String? vigenciaHasta;
  final double? precio;

  /// `"conekta"` / `"paypal"` — necesario para saber a qué endpoint de
  /// cancelación llamar (`POST .../conekta/subscriptions/cancel` no lleva id,
  /// `POST .../paypal/subscriptions/{id}/cancel` sí).
  final String? provider;

  /// PK interna de `SubscriptionOut` en Pagos (`id`, un UUID) — es la que
  /// espera `POST /paypal/subscriptions/{id}/cancel`. NO confundir con
  /// [providerSubscriptionId] (el id que le puso PayPal, ej. "I-XXXX...");
  /// mandar ese en vez de este da 404 (`session.get()` no lo encuentra por
  /// esa PK) y la suscripción se queda activa sin avisar del error.
  final String? id;

  /// Id de la suscripción del lado del proveedor (`provider_subscription_id`
  /// en el back-end) — solo informativo, no sirve para cancelar.
  final String? providerSubscriptionId;

  const SubscriptionEntity({
    required this.plan,
    required this.estado,
    this.vigenciaHasta,
    this.precio,
    this.provider,
    this.id,
    this.providerSubscriptionId,
  });

  bool get esConekta => (provider ?? '').toLowerCase().contains('conekta');
  bool get esPaypal => (provider ?? '').toLowerCase().contains('paypal');

  // Pagos también bloquea un nuevo `subscribe()` con status `pending`
  // (`_ACTIVE = (active, pending)` en su `subscriptions_router.py`), no solo
  // `active` — si aquí solo mirábamos "activ", una suscripción pendiente se
  // veía como "sin plan" del lado del cliente y dejaba reintentar un pago
  // que el back-end iba a rechazar de todos modos con 400.
  bool get activa {
    final e = estado.toLowerCase();
    return e.contains('activ') || e.contains('pend');
  }

  factory SubscriptionEntity.fromJson(Map<String, dynamic> json) {
    double? d(dynamic v) => v is num ? v.toDouble() : null;
    return SubscriptionEntity(
      // `plan_key` es el campo real de `SubscriptionOut` (Pagos); se dejan
      // los demás como fallback por si algún proxy manda otra forma.
      plan: (json['plan_key'] ??
              json['plan'] ??
              json['nombre_plan'] ??
              json['nombre'] ??
              json['plan_nombre'] ??
              'Plan')
          .toString(),
      estado: (json['status'] ?? json['estado'] ?? '').toString(),
      vigenciaHasta: (json['current_period_end'] ??
              json['vigencia_hasta'] ??
              json['fecha_fin'] ??
              json['fecha_vencimiento'] ??
              json['vence'] ??
              json['expira'])
          ?.toString(),
      precio: d(json['precio'] ?? json['monto'] ?? json['costo']),
      provider: json['provider']?.toString(),
      id: json['id']?.toString(),
      providerSubscriptionId: json['provider_subscription_id']?.toString(),
    );
  }
}
