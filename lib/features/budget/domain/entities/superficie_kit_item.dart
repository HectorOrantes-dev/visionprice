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

  /// Desde `cuerpo_confirmacion.kit.superficies[i]` (`POST /cotizaciones/borrador`),
  /// ya en el mismo shape que espera `POST /cotizaciones/kit`.
  factory SuperficieKitItem.fromJson(Map<String, dynamic> json) {
    return SuperficieKitItem(
      areaM2:
          (json['area_m2'] is num) ? (json['area_m2'] as num).toDouble() : 0,
      principalProductoId: (json['principal_producto_id'] ?? '').toString(),
      descripcion: json['descripcion']?.toString(),
      metodoCrucetas: (json['metodo_crucetas'] ?? 'tradicional').toString(),
      adhesivoProductoId: json['adhesivo_producto_id']?.toString(),
      cruecetaProductoId: json['cruceta_producto_id']?.toString(),
      boquillaProductoId: json['boquilla_producto_id']?.toString(),
    );
  }

  SuperficieKitItem copyWith({
    String? principalProductoId,
    String? adhesivoProductoId,
    String? cruecetaProductoId,
    String? boquillaProductoId,
  }) {
    return SuperficieKitItem(
      areaM2: areaM2,
      principalProductoId: principalProductoId ?? this.principalProductoId,
      descripcion: descripcion,
      metodoCrucetas: metodoCrucetas,
      adhesivoProductoId: adhesivoProductoId ?? this.adhesivoProductoId,
      cruecetaProductoId: cruecetaProductoId ?? this.cruecetaProductoId,
      boquillaProductoId: boquillaProductoId ?? this.boquillaProductoId,
    );
  }

  Map<String, dynamic> toJson() => {
        'area_m2': areaM2,
        'principal_producto_id': principalProductoId,
        if (descripcion != null) 'descripcion': descripcion,
        'metodo_crucetas': metodoCrucetas,
        if (adhesivoProductoId != null)
          'adhesivo_producto_id': adhesivoProductoId,
        if (cruecetaProductoId != null)
          'cruceta_producto_id': cruecetaProductoId,
        if (boquillaProductoId != null)
          'boquilla_producto_id': boquillaProductoId,
      };
}
