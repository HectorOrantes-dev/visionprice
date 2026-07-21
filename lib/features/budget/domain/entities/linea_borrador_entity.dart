/// Una línea del borrador (`POST /cotizaciones/borrador`): un producto ya
/// auto-seleccionado (proveedor más barato cercano) para un rol dentro de la
/// superficie — `principal/adhesivo/cruceta/boquilla` si es kit, o
/// `material` si es de rendimiento (pintura/impermeabilizante).
class LineaBorradorEntity {
  final String rol;
  final String productoId;
  final String nombre;
  final String? proveedorNombre;
  final double? distanciaKm;
  final double cantidad;
  final String unidad;
  final double precioUnitario;
  final double subtotal;
  final String? detalle;

  /// Solo de UI: `true` si el usuario cambió el producto de esta línea. El
  /// back-end no recalcula cantidad/subtotal al editar (ver nota en
  /// `BorradorCotizacionEntity`), así que se muestra como "se recalculará".
  final bool editado;

  const LineaBorradorEntity({
    required this.rol,
    required this.productoId,
    required this.nombre,
    this.proveedorNombre,
    this.distanciaKm,
    required this.cantidad,
    required this.unidad,
    required this.precioUnitario,
    required this.subtotal,
    this.detalle,
    this.editado = false,
  });

  factory LineaBorradorEntity.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) => v is num ? v.toDouble() : 0;
    double? dn(dynamic v) => v is num ? v.toDouble() : null;
    return LineaBorradorEntity(
      rol: (json['rol'] ?? '').toString(),
      productoId: (json['producto_id'] ?? '').toString(),
      nombre: (json['nombre'] ?? '').toString(),
      proveedorNombre: json['proveedor_nombre']?.toString(),
      distanciaKm: dn(json['distancia_km']),
      cantidad: d(json['cantidad']),
      unidad: (json['unidad'] ?? '').toString(),
      precioUnitario: d(json['precio_unitario']),
      subtotal: d(json['subtotal']),
      detalle: json['detalle']?.toString(),
    );
  }

  LineaBorradorEntity copyWithProducto({
    required String productoId,
    required String nombre,
    String? proveedorNombre,
    double? distanciaKm,
    required double precioUnitario,
  }) {
    return LineaBorradorEntity(
      rol: rol,
      productoId: productoId,
      nombre: nombre,
      proveedorNombre: proveedorNombre,
      distanciaKm: distanciaKm,
      cantidad: cantidad,
      unidad: unidad,
      precioUnitario: precioUnitario,
      subtotal: subtotal,
      detalle: detalle,
      editado: true,
    );
  }
}
