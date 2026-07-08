/// Producto/material disponible en una ferretería cercana
/// (`GET /api/v1/cotizaciones/productos`).
class ProductoEntity {
  final String productoId; // string para cumplir el contrato de la API
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

    // La imagen puede venir con distintos nombres de clave según el back
    // (image_url, imagen_url, imagen, foto…) y a veces anidada en el producto.
    String? firstUrl(Map map) {
      const keys = [
        'image_url',
        'imagen_url',
        'imagen',
        'image',
        'url_imagen',
        'foto',
        'foto_url',
        'thumbnail',
      ];
      for (final k in keys) {
        final v = map[k];
        if (v != null && v.toString().trim().isNotEmpty) return v.toString();
      }
      return null;
    }

    final productoObj = json['producto'] is Map ? json['producto'] : null;
    final imagen = firstUrl(json) ??
        (productoObj != null ? firstUrl(productoObj) : null);

    return ProductoEntity(
      productoId: (json['producto_id'] ?? '').toString(),
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
      imageUrl: imagen,
    );
  }
}
