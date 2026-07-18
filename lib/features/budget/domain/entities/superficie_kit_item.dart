/// Una superficie tipo KIT lista para enviar a `POST /cotizaciones/kit`
/// (loseta/piso/azulejo/zoclo: producto principal + complementos).
class SuperficieKitItem {
  final double areaM2;
  final String principalProductoId;
  final String? descripcion;
  final String metodoCrucetas; // 'interseccion' | 'tradicional' | 'nivelacion'
  final String? adhesivoProductoId;
  final String? cruecetaProductoId;
  final String? boquillaProductoId;

  const SuperficieKitItem({
    required this.areaM2,
    required this.principalProductoId,
    this.descripcion,
    this.metodoCrucetas = 'tradicional',
    this.adhesivoProductoId,
    this.cruecetaProductoId,
    this.boquillaProductoId,
  });

  Map<String, dynamic> toJson() => {
        'area_m2': areaM2,
        'principal_producto_id': principalProductoId,
        if (descripcion != null) 'descripcion': descripcion,
        'metodo_crucetas': metodoCrucetas,
        if (adhesivoProductoId != null) 'adhesivo_producto_id': adhesivoProductoId,
        if (cruecetaProductoId != null) 'cruceta_producto_id': cruecetaProductoId,
        if (boquillaProductoId != null) 'boquilla_producto_id': boquillaProductoId,
      };
}
