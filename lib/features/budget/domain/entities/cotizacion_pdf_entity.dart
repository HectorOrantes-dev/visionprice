/// Una cotización con su PDF descargable, tal como la devuelve
/// `GET /api/v1/cotizaciones/pdfs` (todas las cotizaciones del usuario, en todas
/// sus obras). Los PDFs se generan al vuelo: [urlPdf] es el enlace real de
/// descarga (`GET /cotizaciones/{id}/pdf`).
class CotizacionPdfEntity {
  /// Identificador interno: solo arma la URL de descarga (`urlPdf`/
  /// `GET /cotizaciones/{id}/pdf`). Para mostrar al usuario está [numero].
  final int id;

  /// Número de cotización "amigable" para mostrar (`Cotización #$numero`).
  final int numero;
  final int proyectoId;
  final String proyectoNombre;
  final String estado;
  final double total;
  final String fecha;
  final String urlPdf;

  const CotizacionPdfEntity({
    required this.id,
    required this.numero,
    required this.proyectoId,
    required this.proyectoNombre,
    required this.estado,
    required this.total,
    required this.fecha,
    required this.urlPdf,
  });

  factory CotizacionPdfEntity.fromJson(Map<String, dynamic> json) {
    int i(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}') ?? 0;
    final id = i(json['id']);
    return CotizacionPdfEntity(
      id: id,
      // Respuestas viejas (sin `numero`, o caché local previo a esta versión)
      // caen de vuelta al `id`.
      numero: json['numero'] == null ? id : i(json['numero']),
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
        'numero': numero,
        'proyecto_id': proyectoId,
        'proyecto_nombre': proyectoNombre,
        'estado': estado,
        'total': total,
        'fecha': fecha,
        'url_pdf': urlPdf,
      };
}
