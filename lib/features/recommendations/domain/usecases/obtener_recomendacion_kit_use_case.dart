import '../entities/recomendacion_kit_entity.dart';
import '../repositories/recomendacion_repository.dart';

/// Pide la recomendación de kit para una zona/categoría/área. Cualquier rol.
class ObtenerRecomendacionKitUseCase {
  final RecomendacionRepository _repo;
  ObtenerRecomendacionKitUseCase(this._repo);

  Future<RecomendacionKitEntity> call({
    required double lat,
    required double lng,
    required String categoria,
    required double areaM2,
    int? proyectoId,
    int? k,
  }) =>
      _repo.recomendarKit(
        lat: lat,
        lng: lng,
        categoria: categoria,
        areaM2: areaM2,
        proyectoId: proyectoId,
        k: k,
      );
}
