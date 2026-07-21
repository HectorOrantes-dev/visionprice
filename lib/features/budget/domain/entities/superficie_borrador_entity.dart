import 'linea_borrador_entity.dart';

/// Una superficie detectada dentro del borrador, con sus líneas ya resueltas
/// (producto + proveedor auto-elegido por línea).
class SuperficieBorradorEntity {
  final String categoria;
  final String descripcion;
  final double areaM2;

  /// 'kit' (piso/azulejo/zoclo: principal + complementos) o 'rendimiento'
  /// (pintura/impermeabilizante: una sola línea "material").
  final String metodo;
  final List<LineaBorradorEntity> lineas;

  const SuperficieBorradorEntity({
    required this.categoria,
    required this.descripcion,
    required this.areaM2,
    required this.metodo,
    required this.lineas,
  });

  bool get esKit => metodo == 'kit';

  factory SuperficieBorradorEntity.fromJson(Map<String, dynamic> json) {
    final lineasJson = json['lineas'];
    return SuperficieBorradorEntity(
      categoria: (json['categoria'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      areaM2: (json['area_m2'] is num) ? (json['area_m2'] as num).toDouble() : 0,
      metodo: (json['metodo'] ?? '').toString(),
      lineas: lineasJson is List
          ? lineasJson
              .whereType<Map<String, dynamic>>()
              .map(LineaBorradorEntity.fromJson)
              .toList()
          : const [],
    );
  }

  SuperficieBorradorEntity copyWithLineas(List<LineaBorradorEntity> lineas) {
    return SuperficieBorradorEntity(
      categoria: categoria,
      descripcion: descripcion,
      areaM2: areaM2,
      metodo: metodo,
      lineas: lineas,
    );
  }
}
