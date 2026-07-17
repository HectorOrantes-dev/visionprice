/// Resultado de `POST /api/v1/recomendaciones/kit`: qué kit y complementos
/// sugiere el modelo (árbol Gini + K-NN) para una zona/categoría/área.
class RecomendacionKitEntity {
  /// Id que devuelve el back-end para cerrar el loop: se manda de vuelta en
  /// `POST /cotizaciones/kit` para marcar la recomendación como usada.
  final int? recomendacionId;
  final String tipoKit;
  final List<String> complementosRecomendados;
  final String metodoCrucetasRecomendado;
  final String zonaReferencia;
  final int nObrasSimilares;

  const RecomendacionKitEntity({
    this.recomendacionId,
    required this.tipoKit,
    required this.complementosRecomendados,
    required this.metodoCrucetasRecomendado,
    required this.zonaReferencia,
    required this.nObrasSimilares,
  });

  factory RecomendacionKitEntity.fromJson(Map<String, dynamic> json) {
    final comps = json['complementos_recomendados'];
    return RecomendacionKitEntity(
      recomendacionId: json['recomendacion_id'] is int
          ? json['recomendacion_id'] as int
          : int.tryParse('${json['recomendacion_id'] ?? ''}'),
      tipoKit: (json['tipo_kit'] ?? '').toString(),
      complementosRecomendados: comps is List
          ? comps.map((e) => e.toString()).toList()
          : const [],
      metodoCrucetasRecomendado:
          (json['metodo_crucetas_recomendado'] ?? '').toString(),
      zonaReferencia: (json['zona_referencia'] ?? '').toString(),
      nObrasSimilares: json['n_obras_similares'] is int
          ? json['n_obras_similares'] as int
          : int.tryParse('${json['n_obras_similares'] ?? ''}') ?? 0,
    );
  }
}
