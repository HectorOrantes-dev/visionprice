/// Regla de cotización de una categoría de material
/// (`GET /api/v1/cotizaciones/materiales`): si es "simple" (un producto,
/// cantidad por rendimiento) o "kit" (producto principal + complementos).
class MaterialReglaEntity {
  final String categoria;
  final String metodoCalculo; // 'rendimiento' | 'kit'
  final bool requiereKit;
  final List<String> complementos;

  const MaterialReglaEntity({
    required this.categoria,
    required this.metodoCalculo,
    required this.requiereKit,
    this.complementos = const [],
  });

  factory MaterialReglaEntity.fromJson(Map<String, dynamic> json) {
    final comp = json['complementos'];
    return MaterialReglaEntity(
      categoria: (json['categoria'] ?? '').toString(),
      metodoCalculo: (json['metodo_calculo'] ?? '').toString(),
      requiereKit: json['requiere_kit'] == true,
      complementos:
          comp is List ? comp.map((e) => e.toString()).toList() : const [],
    );
  }
}
