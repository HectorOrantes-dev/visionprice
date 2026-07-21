import 'analisis_precio_entity.dart';

/// Una línea de un presupuesto con su análisis de precio. `materialId: null`
/// (ej. mano de obra) siempre trae `severidad: sin_datos` con una razón
/// explícita — se trata como "no auditable", no como error.
class LineaAuditoriaEntity {
  final int detalleId;
  final int presupuestoId;
  final String? materialId;
  final String descripcion;
  final double precioUnitario;
  final AnalisisPrecioEntity analisis;

  const LineaAuditoriaEntity({
    required this.detalleId,
    required this.presupuestoId,
    this.materialId,
    required this.descripcion,
    required this.precioUnitario,
    required this.analisis,
  });

  factory LineaAuditoriaEntity.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) => v is num ? v.toDouble() : 0;
    return LineaAuditoriaEntity(
      detalleId: (json['detalle_id'] as num?)?.toInt() ?? 0,
      presupuestoId: (json['presupuesto_id'] as num?)?.toInt() ?? 0,
      materialId: json['material_id']?.toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      precioUnitario: d(json['precio_unitario']),
      analisis: AnalisisPrecioEntity.fromJson(
        (json['analisis'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }
}
