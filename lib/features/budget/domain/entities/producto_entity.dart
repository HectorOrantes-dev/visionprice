/// Producto/material disponible en una ferretería cercana
/// (`GET /api/v1/cotizaciones/productos`).
class ProductoEntity {
  final int productoId;
  final String nombre;
  final String categoria;
  final String unidad;
  final double precioUnitario;
  final double? rendimientoM2;
  final double? piezaLargoM;
  final double? piezaAnchoM;
  final int? piezasPorCaja;
  final int? proveedorId;
  final String? proveedorNombre;
  final double? distanciaKm;
  final double? proveedorLat;
  final double? proveedorLng;
  final String? imageUrl;

  const ProductoEntity({
    required this.productoId,
    required this.nombre,
    required this.categoria,
    required this.unidad,
    required this.precioUnitario,
    this.rendimientoM2,
    this.piezaLargoM,
    this.piezaAnchoM,
    this.piezasPorCaja,
    this.proveedorId,
    this.proveedorNombre,
    this.distanciaKm,
    this.proveedorLat,
    this.proveedorLng,
    this.imageUrl,
  });

  factory ProductoEntity.fromJson(Map<String, dynamic> json) {
    double? d(dynamic v) => v is num ? v.toDouble() : null;
    int? i(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}');
    
    final prov = json['proveedor'] is Map ? json['proveedor'] : null;

    return ProductoEntity(
      productoId: i(json['producto_id']) ?? 0,
      nombre: (json['nombre'] ?? '').toString(),
      categoria: (json['categoria'] ?? '').toString(),
      unidad: (json['unidad'] ?? '').toString(),
      precioUnitario: d(json['precio_unitario']) ?? 0,
      rendimientoM2: d(json['rendimiento_m2']),
      piezaLargoM: d(json['pieza_largo_m']),
      piezaAnchoM: d(json['pieza_ancho_m']),
      piezasPorCaja: i(json['piezas_por_caja']),
      proveedorId: prov != null ? i(prov['proveedor_id']) : i(json['proveedor_id']),
      proveedorNombre: prov != null ? prov['nombre']?.toString() : json['proveedor_nombre']?.toString(),
      distanciaKm: prov != null ? d(prov['distancia_km']) : d(json['distancia_km']),
      proveedorLat: prov != null ? d(prov['lat']) : d(json['proveedor_lat']),
      proveedorLng: prov != null ? d(prov['lng']) : d(json['proveedor_lng']),
      imageUrl: (json['image_url'] ?? '').toString().isNotEmpty ? json['image_url'].toString() : null,
    );
  }
}
