class SuperficieEntity {
  final String tipo; // ej. 'piso', 'pared'
  final String descripcion; // ej. 'piso sala'
  final double areaM2;

  const SuperficieEntity({
    required this.tipo,
    required this.descripcion,
    required this.areaM2,
  });

  factory SuperficieEntity.fromJson(Map<String, dynamic> json) {
    // El ML manda "tipo_superficie" y puede mandar "ubicacion" como descripción.
    // Soporta también el formato plano legacy que usaba "tipo" y "descripcion".
    final tipo =
        json['tipo_superficie']?.toString() ??
        json['tipo']?.toString() ??
        'desconocido';

    final ubicacion = json['ubicacion']?.toString();
    final descripcionRaw = json['descripcion']?.toString();
    final descripcion = (descripcionRaw != null && descripcionRaw.isNotEmpty)
        ? descripcionRaw
        : (ubicacion != null && ubicacion.isNotEmpty)
            ? ubicacion
            : tipo; // fallback: usar el tipo como descripción visible

    // El ML manda area_m2 dentro de "dimensiones", o directo en el item (legacy).
    final dimensiones = json['dimensiones'];
    final areaRaw = (dimensiones is Map<String, dynamic>)
        ? dimensiones['area_m2']
        : json['area_m2'];

    final areaM2 = (areaRaw is num)
        ? areaRaw.toDouble()
        : double.tryParse(areaRaw?.toString() ?? '') ?? 0.0;

    return SuperficieEntity(
      tipo: tipo,
      descripcion: descripcion,
      areaM2: areaM2,
    );
  }
}
