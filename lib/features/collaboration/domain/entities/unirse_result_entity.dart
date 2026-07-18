import 'project_role.dart';

class UnirseResultEntity {
  final int proyectoId;
  final String proyectoNombre;
  final ProjectRole rol;

  const UnirseResultEntity({
    required this.proyectoId,
    required this.proyectoNombre,
    required this.rol,
  });

  factory UnirseResultEntity.fromJson(Map<String, dynamic> json) {
    return UnirseResultEntity(
      proyectoId: json['proyecto_id'] is int ? json['proyecto_id'] as int : int.tryParse('${json['proyecto_id']}') ?? 0,
      proyectoNombre: (json['proyecto_nombre'] ?? '').toString(),
      rol: ProjectRole.fromApi((json['rol_en_proyecto'] ?? '').toString()),
    );
  }
}
