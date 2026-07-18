/// Resultado de `POST /api/v1/recomendaciones/kit`: qué kit y complementos
/// sugiere el modelo (árbol Gini + K-NN) para una zona/categoría/área, más los
/// productos concretos recomendados por categoría para autollenar los widgets.
class RecomendacionKitEntity {
  /// Id que devuelve el back-end para cerrar el loop: se manda de vuelta en
  /// `POST /cotizaciones/kit` para marcar la recomendación como usada.
  final int? recomendacionId;
  final String tipoKit;
  final double confianzaTipoKit;
  final List<String> complementosRecomendados;
  final String metodoCrucetasRecomendado;
  final String zonaReferencia;
  final int nObrasSimilares;

  /// Productos recomendados por categoría (hasta 3, ordenados por cercanía),
  /// tal como los manda el back-end. Se dejan como JSON crudo para no acoplar el
  /// dominio de recomendaciones con la entidad de producto de otra feature: la
  /// capa de presentación los convierte a `ProductoEntity` al autollenar.
  ///
  /// Claves: la categoría principal (`azulejo`/`piso`/`zoclo`) + `pegazulejo`,
  /// `cruceta`, `emboquillado`. Una categoría puede venir vacía o ausente.
  final Map<String, List<Map<String, dynamic>>> materialesRecomendados;

  const RecomendacionKitEntity({
    this.recomendacionId,
    required this.tipoKit,
    this.confianzaTipoKit = 0,
    required this.complementosRecomendados,
    required this.metodoCrucetasRecomendado,
    required this.zonaReferencia,
    required this.nObrasSimilares,
    this.materialesRecomendados = const {},
  });

  /// `true` si el back-end sugiere un KIT (piso/azulejo/zoclo) y no un material
  /// simple por rendimiento (pintura).
  bool get esKit => tipoKit.toLowerCase() == 'kit';

  /// Primer producto recomendado de [categoria] (el más cercano), o `null` si no
  /// hay ninguno.
  Map<String, dynamic>? primerProducto(String categoria) {
    final lista = materialesRecomendados[categoria];
    if (lista == null || lista.isEmpty) return null;
    return lista.first;
  }

  factory RecomendacionKitEntity.fromJson(Map<String, dynamic> json) {
    final comps = json['complementos_recomendados'];

    // materiales_recomendados: { categoria: [ {producto...}, ... ] }
    final matsRaw = json['materiales_recomendados'];
    final mats = <String, List<Map<String, dynamic>>>{};
    if (matsRaw is Map) {
      matsRaw.forEach((k, v) {
        if (v is List) {
          mats['$k'] = v.whereType<Map<String, dynamic>>().toList();
        }
      });
    }

    return RecomendacionKitEntity(
      recomendacionId: json['recomendacion_id'] is int
          ? json['recomendacion_id'] as int
          : int.tryParse('${json['recomendacion_id'] ?? ''}'),
      tipoKit: (json['tipo_kit'] ?? '').toString(),
      confianzaTipoKit: json['confianza_tipo_kit'] is num
          ? (json['confianza_tipo_kit'] as num).toDouble()
          : 0,
      complementosRecomendados: comps is List
          ? comps.map((e) => e.toString()).toList()
          : const [],
      metodoCrucetasRecomendado:
          (json['metodo_crucetas_recomendado'] ?? '').toString(),
      zonaReferencia: (json['zona_referencia'] ?? '').toString(),
      nObrasSimilares: json['n_obras_similares'] is int
          ? json['n_obras_similares'] as int
          : int.tryParse('${json['n_obras_similares'] ?? ''}') ?? 0,
      materialesRecomendados: mats,
    );
  }
}
