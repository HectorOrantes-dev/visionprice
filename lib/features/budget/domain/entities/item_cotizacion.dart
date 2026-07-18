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

  Map<String, dynamic> toJson() => {
        'producto_id': productoId, // string: "12345" o "uuid-xxx"
        if (aplicarA != null) 'aplicar_a': aplicarA,
        if (areaM2 != null) 'area_m2': areaM2,
        if (descripcion != null) 'descripcion': descripcion,
      };
}
