/// Una notificación del usuario (`GET /api/v1/notificaciones`).
class NotificacionEntity {
  final int id;
  final String tipo;
  final String titulo;
  final String cuerpo;
  final bool leida;
  final String? fechaCreacion;

  const NotificacionEntity({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.cuerpo,
    required this.leida,
    this.fechaCreacion,
  });

  factory NotificacionEntity.fromJson(Map<String, dynamic> json) {
    return NotificacionEntity(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      tipo: (json['tipo'] ?? '').toString(),
      titulo: (json['titulo'] ?? '').toString(),
      cuerpo: (json['cuerpo'] ?? json['mensaje'] ?? '').toString(),
      leida: json['leida'] == true,
      fechaCreacion:
          (json['fecha_creacion'] ?? json['fecha_envio'])?.toString(),
    );
  }

  NotificacionEntity copyWith({bool? leida}) => NotificacionEntity(
        id: id,
        tipo: tipo,
        titulo: titulo,
        cuerpo: cuerpo,
        leida: leida ?? this.leida,
        fechaCreacion: fechaCreacion,
      );
}
