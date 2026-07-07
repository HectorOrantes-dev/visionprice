class SyncItemEntity {
  final String localId;
  final String audioPath;
  final int proyectoId;
  final int? duracionSegundos;
  final String fechaGrabacion;
  final String estado; // pending, uploading, processing, ready, error
  final double progreso;
  final int? apiId;

  const SyncItemEntity({
    required this.localId,
    required this.audioPath,
    required this.proyectoId,
    this.duracionSegundos,
    required this.fechaGrabacion,
    required this.estado,
    required this.progreso,
    this.apiId,
  });

  factory SyncItemEntity.fromMap(Map<String, dynamic> map) {
    return SyncItemEntity(
      localId: map['local_id'],
      audioPath: map['audio_path'],
      proyectoId: map['proyecto_id'],
      duracionSegundos: map['duracion_segundos'],
      fechaGrabacion: map['fecha_grabacion'],
      estado: map['estado'],
      progreso: map['progreso'] ?? 0.0,
      apiId: map['api_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'local_id': localId,
      'audio_path': audioPath,
      'proyecto_id': proyectoId,
      'duracion_segundos': duracionSegundos,
      'fecha_grabacion': fechaGrabacion,
      'estado': estado,
      'progreso': progreso,
      'api_id': apiId,
    };
  }

  SyncItemEntity copyWith({
    String? estado,
    double? progreso,
    int? apiId,
  }) {
    return SyncItemEntity(
      localId: localId,
      audioPath: audioPath,
      proyectoId: proyectoId,
      duracionSegundos: duracionSegundos,
      fechaGrabacion: fechaGrabacion,
      estado: estado ?? this.estado,
      progreso: progreso ?? this.progreso,
      apiId: apiId ?? this.apiId,
    );
  }
}
