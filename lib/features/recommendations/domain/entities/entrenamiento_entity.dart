/// Resultado de `POST /api/v1/recomendaciones/entrenar`.
///
/// [nObrasReales] es el indicador clave: cuenta las obras del usuario que sí
/// tenían ubicación (paso 1). Si es 0, ninguna obra real entró al dataset y el
/// modelo se entrenó solo con datos sintéticos.
class EntrenamientoEntity {
  final int nObras;
  final int nObrasReales;
  final int nObrasSinteticas;
  final double accuracyArbolTipoKit;

  const EntrenamientoEntity({
    required this.nObras,
    required this.nObrasReales,
    required this.nObrasSinteticas,
    required this.accuracyArbolTipoKit,
  });

  factory EntrenamientoEntity.fromJson(Map<String, dynamic> json) {
    int i(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}') ?? 0;
    return EntrenamientoEntity(
      nObras: i(json['n_obras']),
      nObrasReales: i(json['n_obras_reales']),
      nObrasSinteticas: i(json['n_obras_sinteticas']),
      accuracyArbolTipoKit: json['accuracy_arbol_tipo_kit'] is num
          ? (json['accuracy_arbol_tipo_kit'] as num).toDouble()
          : 0,
    );
  }
}
