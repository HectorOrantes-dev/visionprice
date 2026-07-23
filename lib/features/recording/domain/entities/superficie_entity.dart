class SuperficieEntity {
  final String tipo; // SUPERFICIE que se interviene, ej. 'pared', 'piso'
  final String descripcion; // ej. 'piso sala'
  final double areaM2;

  /// MATERIAL a cotizar, ej. 'pintura', 'piso', 'azulejo'. Es lo que se usa
  /// para consultar el catálogo (`categoria=`) y para saber si es simple o kit
  /// (`GET /cotizaciones/materiales`). Distinto de [tipo]: una 'pared' se pinta
  /// con 'pintura'. El ML lo manda en `categoria` (o `materiales[0]`).
  final String categoria;

  const SuperficieEntity({
    required this.tipo,
    required this.descripcion,
    required this.areaM2,
    required this.categoria,
  });

  factory SuperficieEntity.fromJson(Map<String, dynamic> json) {
    // El ML manda "tipo_superficie" y puede mandar "ubicacion" como descripción.
    // Soporta también el formato plano legacy que usaba "tipo" y "descripcion".
    final tipo = json['tipo_superficie']?.toString() ??
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

    // El material a cotizar: el ML lo manda en "categoria" (o en "materiales").
    // Si no viene, se cae a "tipo" (compatibilidad con extracciones viejas).
    final materiales = json['materiales'];
    final categoriaRaw = json['categoria']?.toString();
    final categoria = (categoriaRaw != null && categoriaRaw.isNotEmpty)
        ? categoriaRaw
        : (materiales is List && materiales.isNotEmpty)
            ? materiales.first.toString()
            : tipo;

    return SuperficieEntity(
      tipo: tipo,
      descripcion: descripcion,
      areaM2: areaM2,
      categoria: categoria,
    );
  }
}
