/// Resultado del cálculo de metros (`POST /cotizaciones/calculo`): dimensiones
/// y áreas derivadas de la transcripción de la grabación.
class CalculoEntity {
  final double? largoM;
  final double? anchoM;
  final double? altoM;
  final double? pisoM2;
  final double? paredesM2;
  final List<String> advertencias;

  const CalculoEntity({
    this.largoM,
    this.anchoM,
    this.altoM,
    this.pisoM2,
    this.paredesM2,
    this.advertencias = const [],
  });

  factory CalculoEntity.fromJson(Map<String, dynamic> json) {
    double? num2(dynamic v) => v is num ? v.toDouble() : null;
    final adv = json['advertencias'];
    return CalculoEntity(
      largoM: num2(json['largo_m']),
      anchoM: num2(json['ancho_m']),
      altoM: num2(json['alto_m']),
      pisoM2: num2(json['piso_m2']),
      paredesM2: num2(json['paredes_m2']),
      advertencias:
          adv is List ? adv.map((e) => e.toString()).toList() : const [],
    );
  }
}
