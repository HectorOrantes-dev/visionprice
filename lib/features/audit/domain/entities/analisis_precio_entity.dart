/// Análisis estadístico de una línea de auditoría de precios.
///
/// `mediana`/`limiteInferior`/`limiteSuperior` vienen `null` cuando
/// `nHistorico < 3` (histórico insuficiente para auditar) — la UI debe
/// manejar ese caso sin reventar, no hay rango que graficar.
class AnalisisPrecioEntity {
  final int nHistorico;
  final double? mediana;
  final bool esAnomalia;

  /// 'sin_datos' | 'normal' | 'revisar' | 'critico'. Solo 'revisar' y
  /// 'critico' implican `esAnomalia: true`.
  final String severidad;
  final List<String> razones;
  final double? limiteInferior;
  final double? limiteSuperior;

  const AnalisisPrecioEntity({
    required this.nHistorico,
    this.mediana,
    required this.esAnomalia,
    required this.severidad,
    required this.razones,
    this.limiteInferior,
    this.limiteSuperior,
  });

  factory AnalisisPrecioEntity.fromJson(Map<String, dynamic> json) {
    double? d(dynamic v) => v is num ? v.toDouble() : null;
    final razonesJson = json['razones'];
    return AnalisisPrecioEntity(
      nHistorico: (json['n_historico'] as num?)?.toInt() ?? 0,
      mediana: d(json['mediana']),
      esAnomalia: json['es_anomalia'] == true,
      severidad: (json['severidad'] ?? 'sin_datos').toString(),
      razones: razonesJson is List
          ? razonesJson.map((e) => e.toString()).toList()
          : const [],
      limiteInferior: d(json['limite_inferior']),
      limiteSuperior: d(json['limite_superior']),
    );
  }
}
