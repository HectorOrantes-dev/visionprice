/// Uso de la cuota gratis de cotizaciones (`GET /cotizaciones/uso`): 20 de
/// por vida sin plan pagado, ilimitado con plan activo/vigente.
class UsoCotizacionesEntity {
  final String? planActivo;
  final bool ilimitado;
  final int limiteGratis;
  final int usadas;
  final int? restantes;

  const UsoCotizacionesEntity({
    required this.planActivo,
    required this.ilimitado,
    required this.limiteGratis,
    required this.usadas,
    required this.restantes,
  });

  factory UsoCotizacionesEntity.fromJson(Map<String, dynamic> json) {
    return UsoCotizacionesEntity(
      planActivo: json['plan_activo'] as String?,
      ilimitado: json['ilimitado'] == true,
      limiteGratis: (json['limite_gratis'] as num?)?.toInt() ?? 20,
      usadas: (json['usadas'] as num?)?.toInt() ?? 0,
      restantes: (json['restantes'] as num?)?.toInt(),
    );
  }
}
