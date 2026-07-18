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
