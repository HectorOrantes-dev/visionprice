import 'project_role.dart';

class InvitacionEntity {
  final int id;
  final String codigo;
  final ProjectRole rol;
  final String estado;
  final int usos;
  final DateTime fechaExpiracion;

  const InvitacionEntity({
    required this.id,
    required this.codigo,
    required this.rol,
    required this.estado,
    required this.usos,
    required this.fechaExpiracion,
  });

  Duration get expiraEn {
    final now = DateTime.now();
    if (fechaExpiracion.isBefore(now)) return Duration.zero;
    return fechaExpiracion.difference(now);
  }

  factory InvitacionEntity.fromJson(Map<String, dynamic> json) {
    return InvitacionEntity(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      codigo: (json['codigo'] ?? '').toString(),
      rol: ProjectRole.fromApi((json['rol_en_proyecto'] ?? '').toString()),
      estado: (json['estado'] ?? '').toString(),
      usos: json['usos'] is int
          ? json['usos'] as int
          : int.tryParse('${json['usos']}') ?? 0,
      fechaExpiracion:
          DateTime.tryParse('${json['fecha_expiracion']}') ?? DateTime.now(),
    );
  }
}
