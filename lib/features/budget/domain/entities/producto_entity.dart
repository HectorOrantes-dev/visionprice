/// Producto/material disponible en una ferretería cercana
/// (`GET /api/v1/cotizaciones/productos`).
class ProductoEntity {
  final int productoId;
  final String nombre;
  final String categoria;
  final String unidad;
  final double precioUnitario;
  final double? rendimientoM2;
  final int? proveedorId;
  final String? proveedorNombre;
  final double? distanciaKm;

  const ProductoEntity({
    required this.productoId,
    required this.nombre,
    required this.categoria,
    required this.unidad,
    required this.precioUnitario,
    this.rendimientoM2,
    this.proveedorId,
    this.proveedorNombre,
    this.distanciaKm,
  });

  factory ProductoEntity.fromJson(Map<String, dynamic> json) {
    double? d(dynamic v) => v is num ? v.toDouble() : null;
    int? i(dynamic v) =>
        v is int ? v : int.tryParse('${v ?? ''}');
    return ProductoEntity(
      productoId: i(json['producto_id']) ?? 0,
      nombre: (json['nombre'] ?? '').toString(),
      categoria: (json['categoria'] ?? '').toString(),
      unidad: (json['unidad'] ?? '').toString(),
      precioUnitario: d(json['precio_unitario']) ?? 0,
      rendimientoM2: d(json['rendimiento_m2']),
      proveedorId: i(json['proveedor_id']),
      proveedorNombre: json['proveedor_nombre']?.toString(),
      distanciaKm: d(json['distancia_km']),
    );
  }
}
