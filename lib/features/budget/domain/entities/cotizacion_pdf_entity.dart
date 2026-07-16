/// Una cotización con su PDF descargable, tal como la devuelve
/// `GET /api/v1/cotizaciones/pdfs` (todas las cotizaciones del usuario, en todas
/// sus obras). Los PDFs se generan al vuelo: [urlPdf] es el enlace real de
/// descarga (`GET /cotizaciones/{id}/pdf`).
class CotizacionPdfEntity {
  final int id;
  final int proyectoId;
  final String proyectoNombre;
  final String estado;
  final double total;
  final String fecha;
  final String urlPdf;

  const CotizacionPdfEntity({
    required this.id,
    required this.proyectoId,
    required this.proyectoNombre,
    required this.estado,
    required this.total,
    required this.fecha,
    required this.urlPdf,
  });

  factory CotizacionPdfEntity.fromJson(Map<String, dynamic> json) {
    int i(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}') ?? 0;
    return CotizacionPdfEntity(
      id: i(json['id']),
      proyectoId: i(json['proyecto_id']),
      proyectoNombre: (json['proyecto_nombre'] ?? '').toString(),
      estado: (json['estado'] ?? '').toString(),
      total: json['total'] is num ? (json['total'] as num).toDouble() : 0,
      fecha: (json['fecha'] ?? '').toString(),
      urlPdf: (json['url_pdf'] ?? '').toString(),
    );
  }

  /// Mismas claves que [fromJson]: sirve tanto para el JSON del back-end como
  /// para las columnas de la tabla local `cotizaciones_pdf`.
  Map<String, dynamic> toJson() => {
        'id': id,
        'proyecto_id': proyectoId,
        'proyecto_nombre': proyectoNombre,
        'estado': estado,
        'total': total,
        'fecha': fecha,
        'url_pdf': urlPdf,
      };
}
