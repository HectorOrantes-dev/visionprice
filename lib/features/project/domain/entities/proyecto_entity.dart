/// Un proyecto del usuario. Toda grabación/cotización pertenece a un proyecto.
class ProyectoEntity {
  final int id;
  final String nombre;
  final String? direccion;
  final String estado;
  final int totalPresupuestos;

  const ProyectoEntity({
    required this.id,
    required this.nombre,
    this.direccion,
    this.estado = 'activo',
    this.totalPresupuestos = 0,
  });

  factory ProyectoEntity.fromJson(Map<String, dynamic> json) {
    return ProyectoEntity(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      nombre: (json['nombre'] ?? '').toString(),
      direccion: json['direccion']?.toString(),
      estado: (json['estado'] ?? 'activo').toString(),
      totalPresupuestos: json['total_presupuestos'] is int
          ? json['total_presupuestos'] as int
          : int.tryParse('${json['total_presupuestos']}') ?? 0,
    );
  }
}
