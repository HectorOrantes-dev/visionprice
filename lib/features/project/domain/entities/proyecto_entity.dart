/// Un proyecto del usuario. Toda grabación/cotización pertenece a un proyecto.
class ProyectoEntity {
  final int id;
  final String nombre;
  final String? direccion;
  final String estado;
  final int totalPresupuestos;

  /// Ubicación de la obra. Es lo que el modelo de recomendaciones necesita para
  /// poder usarla como obra real de entrenamiento: sin coordenadas, se descarta.
  final double? latitud;
  final double? longitud;

  /// `true` si el usuario actual es el dueño (lo creó) — `false` si es
  /// colaborador invitado. Determina si puede invitar/gestionar el equipo.
  final bool esDueno;

  const ProyectoEntity({
    required this.id,
    required this.nombre,
    this.direccion,
    this.estado = 'activo',
    this.totalPresupuestos = 0,
    this.latitud,
    this.longitud,
    this.esDueno = true,
  });

  /// `true` si la obra ya tiene ubicación (sirve para entrenar).
  bool get tieneUbicacion => latitud != null && longitud != null;

  factory ProyectoEntity.fromJson(Map<String, dynamic> json) {
    double? d(dynamic v) =>
        v is num ? v.toDouble() : double.tryParse('${v ?? ''}');
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
      latitud: d(json['latitud']),
      longitud: d(json['longitud']),
      // Tolerante a bool (JSON del back-end) o 0/1 (fila de SQLite local).
      esDueno: json['es_dueno'] == true || json['es_dueno'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'direccion': direccion,
        'estado': estado,
        'total_presupuestos': totalPresupuestos,
        'latitud': latitud,
        'longitud': longitud,
        'es_dueno': esDueno ? 1 : 0,
      };
}
