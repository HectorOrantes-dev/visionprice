/// Una grabación de audio y su estado de procesamiento ML en el back-end.
/// Sirve tanto para la respuesta de subida (201, solo `id` + estado) como para
/// el detalle (`GET /grabaciones/{id}`) que ya trae transcripción/extracción.
class GrabacionEntity {
  final int id;
  final int? proyectoId;
  final String estado; // estado_sincronizacion: procesando | sincronizado | error
  final int? duracionSegundos;
  final String? transcripcion;
  final double? confianza;
  final Map<String, dynamic>? extraccion; // extraccion_json (entidades del LLM)
  final String? fechaGrabacion;
  final String? fechaSincronizacion;

  const GrabacionEntity({
    required this.id,
    this.proyectoId,
    required this.estado,
    this.duracionSegundos,
    this.transcripcion,
    this.confianza,
    this.extraccion,
    this.fechaGrabacion,
    this.fechaSincronizacion,
  });

  bool get isProcesando => estado == 'procesando';
  bool get isSincronizado => estado == 'sincronizado';
  bool get isError => estado == 'error';
  bool get tieneTranscripcion =>
      transcripcion != null && transcripcion!.isNotEmpty;

  factory GrabacionEntity.fromJson(Map<String, dynamic> json) {
    final confianza = json['confianza'];
    final extraccion = json['extraccion_json'];
    return GrabacionEntity(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      proyectoId: json['proyecto_id'] is int
          ? json['proyecto_id'] as int
          : int.tryParse('${json['proyecto_id']}'),
      estado: (json['estado_sincronizacion'] ?? json['estado'] ?? '').toString(),
      duracionSegundos: json['duracion_segundos'] is int
          ? json['duracion_segundos'] as int
          : int.tryParse('${json['duracion_segundos']}'),
      transcripcion: json['transcripcion']?.toString(),
      confianza: confianza is num ? confianza.toDouble() : null,
      extraccion: extraccion is Map<String, dynamic> ? extraccion : null,
      fechaGrabacion: json['fecha_grabacion']?.toString(),
      fechaSincronizacion: json['fecha_sincronizacion']?.toString(),
    );
  }
}
