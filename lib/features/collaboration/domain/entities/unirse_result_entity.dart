import 'project_role.dart';

/// Resultado de `POST /proyectos/unirse`: el back-end devuelve el
/// `MiembroOut` del usuario que se acaba de unir (SIN `proyecto_id` ni
/// `proyecto_nombre` — esos campos no existen en esa respuesta).
class UnirseResultEntity {
  final int usuarioId;
  final String nombre;
  final String correo;
  final ProjectRole rol;

  const UnirseResultEntity({
    required this.usuarioId,
    required this.nombre,
    required this.correo,
    required this.rol,
  });

  factory UnirseResultEntity.fromJson(Map<String, dynamic> json) {
    return UnirseResultEntity(
      usuarioId: json['usuario_id'] is int
          ? json['usuario_id'] as int
          : int.tryParse('${json['usuario_id']}') ?? 0,
      nombre: (json['nombre'] ?? '').toString(),
      correo: (json['correo'] ?? '').toString(),
      rol: ProjectRole.fromApi((json['rol_en_proyecto'] ?? '').toString()),
    );
  }
}
