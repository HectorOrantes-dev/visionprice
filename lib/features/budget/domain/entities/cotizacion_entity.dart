import 'item_cotizacion.dart';

/// Una línea del resultado de la cotización.
class LineaCotizacionEntity {
  final int? materialId;
  final int? proveedorId;
  final String descripcion;
  final double cantidad;
  final String unidad;
  final double precioUnitario;
  final double subtotal;

  const LineaCotizacionEntity({
    this.materialId,
    this.proveedorId,
    required this.descripcion,
    required this.cantidad,
    required this.unidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory LineaCotizacionEntity.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) => v is num ? v.toDouble() : 0;
    int? i(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}');
    return LineaCotizacionEntity(
      materialId: i(json['material_id']),
      proveedorId: i(json['proveedor_id']),
      descripcion: (json['descripcion'] ?? '').toString(),
      cantidad: d(json['cantidad']),
      unidad: (json['unidad'] ?? '').toString(),
      precioUnitario: d(json['precio_unitario']),
      subtotal: d(json['subtotal']),
    );
  }
}

/// Resultado de crear una cotización (`POST /api/v1/cotizaciones`).
class CotizacionEntity {
  final int id;
  final int proyectoId;
  final String estado;
  final double total;
  final String fecha;
  final List<LineaCotizacionEntity> lineas;

  const CotizacionEntity({
    required this.id,
    required this.proyectoId,
    required this.estado,
    required this.total,
    required this.fecha,
    required this.lineas,
  });

  factory CotizacionEntity.fromJson(Map<String, dynamic> json) {
    final lineas = json['lineas'];
    return CotizacionEntity(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      proyectoId: json['proyecto_id'] is int
          ? json['proyecto_id']
          : int.tryParse('${json['proyecto_id']}') ?? 0,
      estado: (json['estado'] ?? '').toString(),
      total: json['total'] is num ? (json['total'] as num).toDouble() : 0,
      fecha: (json['fecha'] ?? '').toString(),
      lineas: lineas is List
          ? lineas
              .whereType<Map<String, dynamic>>()
              .map(LineaCotizacionEntity.fromJson)
              .toList()
          : const [],
    );
  }
}
