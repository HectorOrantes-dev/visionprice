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

/// Resultado de crear una cotización (`POST /api/v1/cotizaciones`).
class CotizacionEntity {
  final int id;
  final int proyectoId;
  final String estado;
  final double total;

  /// Costo de mano de obra, expuesto por el back-end como campo aparte
  /// (`mano_obra`) además de aparecer como línea en [lineas]/PDF. Es `null`
  /// si la cotización no incluye mano de obra.
  final double? manoObra;
  final String fecha;
  final List<LineaCotizacionEntity> lineas;

  const CotizacionEntity({
    required this.id,
    required this.proyectoId,
    required this.estado,
    required this.total,
    this.manoObra,
    required this.fecha,
    required this.lineas,
  });

  factory CotizacionEntity.fromJson(Map<String, dynamic> json) {
    final lineas = json['lineas'];
    final parsedLineas = lineas is List
        ? lineas
            .whereType<Map<String, dynamic>>()
            .map(LineaCotizacionEntity.fromJson)
            .toList()
        : const <LineaCotizacionEntity>[];

    // `mano_obra` viene del back-end. Si por algún motivo faltara (respuestas
    // viejas), se deriva de la única línea sin `material_id` (siempre es la de
    // mano de obra: las demás vienen de Proveedores y traen `material_id`).
    double? manoObra;
    final raw = json['mano_obra'];
    if (raw is num) {
      manoObra = raw.toDouble();
    } else {
      for (final l in parsedLineas) {
        if (l.materialId == null) {
          manoObra = l.subtotal;
          break;
        }
      }
    }

    return CotizacionEntity(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      proyectoId: json['proyecto_id'] is int
          ? json['proyecto_id']
          : int.tryParse('${json['proyecto_id']}') ?? 0,
      estado: (json['estado'] ?? '').toString(),
      total: json['total'] is num ? (json['total'] as num).toDouble() : 0,
      manoObra: manoObra,
      fecha: (json['fecha'] ?? '').toString(),
      lineas: parsedLineas,
    );
  }
}
