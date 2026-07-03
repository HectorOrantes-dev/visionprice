/// Ítem que se envía al crear una cotización: qué producto y a qué superficie
/// se aplica (`piso` o `paredes`).
class ItemCotizacion {
  final int productoId;
  final String aplicarA; // 'piso' | 'paredes'

  const ItemCotizacion({required this.productoId, required this.aplicarA});

  Map<String, dynamic> toJson() => {
        'producto_id': productoId,
        'aplicar_a': aplicarA,
      };
}
