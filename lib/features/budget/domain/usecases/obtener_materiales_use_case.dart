
import '../entities/material_regla_entity.dart';
import '../repositories/cotizacion_repository.dart';

/// Reglas de cotización por categoría (simple vs. kit).
class ObtenerMaterialesUseCase {
  final CotizacionRepository _repo;
  ObtenerMaterialesUseCase(this._repo);

  Future<List<MaterialReglaEntity>> call() => _repo.materiales();
}
