/// Rol seleccionable en el registro. [value] es lo que se envía al back-end
/// en el campo `rol` (p. ej. `maestro_obra`); [label] es lo que se muestra.
class RoleEntity {
  final String value;
  final String label;

  const RoleEntity({required this.value, required this.label});

  /// Parseo defensivo: acepta un string suelto (`"maestro_obra"`) o un objeto.
  ///
  /// El back-end de registro espera en `rol` el **código string** (p. ej.
  /// `maestro_obra`), no el `id` numérico. Por eso [value] prioriza las claves
  /// de código/nombre y deja `id` como último recurso. La etiqueta visible se
  /// humaniza (`maestro_obra` → `Maestro obra`) salvo que venga un label/desc.
  factory RoleEntity.fromJson(dynamic json) {
    if (json is String) {
      return RoleEntity(value: json, label: _humanize(json));
    }
    final map = json as Map<String, dynamic>;
    final value = (map['codigo'] ??
            map['code'] ??
            map['value'] ??
            map['nombre'] ??
            map['id'] ??
            '')
        .toString();
    final rawLabel = map['label'] ?? map['descripcion'];
    final label = (rawLabel ?? _humanize(value)).toString();
    return RoleEntity(value: value, label: label);
  }

  /// `maestro_obra` → `Maestro obra`.
  static String _humanize(String raw) {
    if (raw.isEmpty) return raw;
    final spaced = raw.replaceAll('_', ' ');
    return spaced[0].toUpperCase() + spaced.substring(1);
  }
}
