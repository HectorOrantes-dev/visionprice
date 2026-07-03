import 'linea_cotizacion_entity.dart';

// Entidades relacionadas, cada una en su propio archivo (SRP); se re-exportan
// para no romper los imports existentes.
export 'item_cotizacion.dart';
export 'linea_cotizacion_entity.dart';

/// Resultado de crear una cotización (`POST /api/v1/cotizaciones`).
class CotizacionEntity {
  final int id;
  final int proyectoId;
  final String estado;
  final double total;
  final String fecha;
  final List<LineaCotizacionEntity> lineas;

  const CotizacionEntity({
    required this.id,
    required this.proyectoId,
    required this.estado,
    required this.total,
    required this.fecha,
    required this.lineas,
  });

  factory CotizacionEntity.fromJson(Map<String, dynamic> json) {
    final lineas = json['lineas'];
    return CotizacionEntity(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      proyectoId: json['proyecto_id'] is int
          ? json['proyecto_id']
          : int.tryParse('${json['proyecto_id']}') ?? 0,
      estado: (json['estado'] ?? '').toString(),
      total: json['total'] is num ? (json['total'] as num).toDouble() : 0,
      fecha: (json['fecha'] ?? '').toString(),
      lineas: lineas is List
          ? lineas
              .whereType<Map<String, dynamic>>()
              .map(LineaCotizacionEntity.fromJson)
              .toList()
          : const [],
    );
  }
}
