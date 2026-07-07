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
    return SuperficieEntity(
      tipo: json['tipo']?.toString() ?? 'desconocido',
      descripcion: json['descripcion']?.toString() ?? 'Sin descripción',
      areaM2: (json['area_m2'] is num)
          ? (json['area_m2'] as num).toDouble()
          : double.tryParse(json['area_m2']?.toString() ?? '0') ?? 0.0,
    );
  }
}
