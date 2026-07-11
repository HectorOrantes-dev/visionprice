
import '../entities/grabacion_entity.dart';
import '../repositories/grabacion_repository.dart';

/// Sube el audio grabado al back-end.
class SubirGrabacionUseCase {
  final GrabacionRepository _repo;
  SubirGrabacionUseCase(this._repo);

  Future<GrabacionEntity> call({
    required String audioPath,
    int? duracionSegundos,
    int? proyectoId,
  }) =>
      _repo.subir(
        audioPath: audioPath,
        duracionSegundos: duracionSegundos,
        proyectoId: proyectoId,
      );
}
