/// Ítem que se envía al crear una cotización: qué producto y a qué superficie
/// se aplica (`piso` o `paredes`). En el nuevo formato (Opción A), se envía
/// el área específica y su descripción en lugar de solo `aplicar_a`.
class ItemCotizacion {
  final String productoId; // siempre string para cumplir el contrato de la API
  final String? aplicarA; // 'piso' | 'paredes' (legacy fallback)
  final double? areaM2;
  final String? descripcion;

  const ItemCotizacion({
    required this.productoId,
    this.aplicarA,
    this.areaM2,
    this.descripcion,
  });

  /// Desde `cuerpo_confirmacion.simple.items[i]` (`POST /cotizaciones/borrador`),
  /// ya en el mismo shape que espera `POST /cotizaciones`.
  factory ItemCotizacion.fromJson(Map<String, dynamic> json) {
    return ItemCotizacion(
      productoId: (json['producto_id'] ?? '').toString(),
      aplicarA: json['aplicar_a']?.toString(),
      areaM2: (json['area_m2'] is num) ? (json['area_m2'] as num).toDouble() : null,
      descripcion: json['descripcion']?.toString(),
    );
  }

  ItemCotizacion copyWithProducto(String productoId) => ItemCotizacion(
        productoId: productoId,
        aplicarA: aplicarA,
        areaM2: areaM2,
        descripcion: descripcion,
      );

  Map<String, dynamic> toJson() => {
        'producto_id': productoId, // string: "12345" o "uuid-xxx"
        if (aplicarA != null) 'aplicar_a': aplicarA,
        if (areaM2 != null) 'area_m2': areaM2,
        if (descripcion != null) 'descripcion': descripcion,
      };
}
