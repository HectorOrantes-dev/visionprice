/// Suscripción del usuario (`GET /api/v1/me/subscriptions`). El back-end no
/// fija un esquema estricto, así que se parsea de forma defensiva.
class SubscriptionEntity {
  final String plan;
  final String estado;
  final String? vigenciaHasta;
  final double? precio;

  const SubscriptionEntity({
    required this.plan,
    required this.estado,
    this.vigenciaHasta,
    this.precio,
  });

  bool get activa => estado.toLowerCase().contains('activ');

  factory SubscriptionEntity.fromJson(Map<String, dynamic> json) {
    double? d(dynamic v) => v is num ? v.toDouble() : null;
    return SubscriptionEntity(
      plan: (json['plan'] ??
              json['nombre_plan'] ??
              json['nombre'] ??
              json['plan_nombre'] ??
              'Plan')
          .toString(),
      estado: (json['estado'] ?? json['status'] ?? '').toString(),
      vigenciaHasta: (json['vigencia_hasta'] ??
              json['fecha_fin'] ??
              json['fecha_vencimiento'] ??
              json['vence'] ??
              json['expira'])
          ?.toString(),
      precio: d(json['precio'] ?? json['monto'] ?? json['costo']),
    );
  }
}
