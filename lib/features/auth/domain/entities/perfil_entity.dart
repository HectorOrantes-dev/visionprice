/// Perfil completo del usuario autenticado, tal como lo devuelve
/// `GET /api/v1/me/perfil` (lee de la BD, no solo del JWT).
///
/// Lleva su propio `fromJson` (sin DTO/model aparte), con parseo defensivo:
/// tolera claves ausentes y fechas nulas para no romper la pantalla de perfil.
class PerfilEntity {
  final int id;
  final String nombre;
  final String correo;
  final String telefono;
  final String rol;
  final bool activo;

  /// Proveedor de autenticación: `local` o `google`.
  final String proveedorAuth;
  final DateTime? fechaRegistro;

  /// Plan contratado (p. ej. `vision-price-pro`) o `null` si no tiene.
  final String? planActivo;
  final DateTime? vigenciaHasta;

  const PerfilEntity({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.rol,
    required this.activo,
    required this.proveedorAuth,
    this.fechaRegistro,
    this.planActivo,
    this.vigenciaHasta,
  });

  bool get tienePlan => (planActivo ?? '').isNotEmpty;

  factory PerfilEntity.fromJson(Map<String, dynamic> json) {
    return PerfilEntity(
      id: int.tryParse('${json['id'] ?? ''}') ?? 0,
      nombre: (json['nombre'] ?? json['name'] ?? '').toString(),
      correo: (json['correo'] ?? json['email'] ?? '').toString(),
      telefono: (json['telefono'] ?? '').toString(),
      rol: (json['rol'] ?? json['role'] ?? '').toString(),
      activo: json['activo'] == true,
      proveedorAuth: (json['proveedor_auth'] ?? 'local').toString(),
      fechaRegistro: _parseDate(json['fecha_registro']),
      planActivo: (json['plan_activo']?.toString().isNotEmpty ?? false)
          ? json['plan_activo'].toString()
          : null,
      vigenciaHasta: _parseDate(json['vigencia_hasta']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
