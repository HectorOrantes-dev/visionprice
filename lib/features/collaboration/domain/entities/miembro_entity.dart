import 'project_role.dart';

class MiembroEntity {
  final int usuarioId;
  final String nombre;
  final String correo;
  final ProjectRole rolEnProyecto;
  final bool esDueno;

  const MiembroEntity({
    required this.usuarioId,
    required this.nombre,
    required this.correo,
    required this.rolEnProyecto,
    required this.esDueno,
  });

  factory MiembroEntity.fromJson(Map<String, dynamic> json) {
    return MiembroEntity(
      usuarioId: json['usuario_id'] is int ? json['usuario_id'] as int : int.tryParse('${json['usuario_id']}') ?? 0,
      nombre: (json['nombre'] ?? '').toString(),
      correo: (json['correo'] ?? '').toString(),
      rolEnProyecto: ProjectRole.fromApi((json['rol_en_proyecto'] ?? '').toString()),
      esDueno: json['es_dueno'] == true,
    );
  }
}
