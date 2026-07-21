import 'linea_auditoria_entity.dart';

/// Resultado de una auditoría de precios (por presupuesto o por zona).
class AuditoriaResultadoEntity {
  final int total;
  final int anomalias;
  final List<LineaAuditoriaEntity> lineas;

  const AuditoriaResultadoEntity({
    required this.total,
    required this.anomalias,
    required this.lineas,
  });

  factory AuditoriaResultadoEntity.fromJson(Map<String, dynamic> json) {
    final lineasJson = json['lineas'];
    return AuditoriaResultadoEntity(
      total: (json['total'] as num?)?.toInt() ?? 0,
      anomalias: (json['anomalias'] as num?)?.toInt() ?? 0,
      lineas: lineasJson is List
          ? lineasJson
              .whereType<Map<String, dynamic>>()
              .map(LineaAuditoriaEntity.fromJson)
              .toList()
          : const [],
    );
  }
}
