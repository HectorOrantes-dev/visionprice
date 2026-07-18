
import '../entities/grabacion_entity.dart';
import '../repositories/grabacion_repository.dart';

/// Detalle de una grabación por id.
class ObtenerGrabacionUseCase {
  final GrabacionRepository _repo;
  ObtenerGrabacionUseCase(this._repo);

  Future<GrabacionEntity> call(int id) => _repo.detalle(id);
}
