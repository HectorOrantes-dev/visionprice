import '../entities/calculo_entity.dart';
import '../entities/grabacion_entity.dart';
import '../repositories/grabacion_repository.dart';

/// Casos de uso del flujo de audio. Cada uno `@injectable` y depende solo del
/// contrato [GrabacionRepository].

class SubirGrabacionUseCase {
  final GrabacionRepository _repo;
  SubirGrabacionUseCase(this._repo);

  Future<GrabacionEntity> call({
    required String audioPath,
    int? duracionSegundos,
    int? proyectoId,
    void Function(double)? onProgress,
  }) =>
      _repo.subir(
        audioPath: audioPath,
        duracionSegundos: duracionSegundos,
        proyectoId: proyectoId,
        onProgress: onProgress,
      );
}

class ObtenerGrabacionUseCase {
  final GrabacionRepository _repo;
  ObtenerGrabacionUseCase(this._repo);

  Future<GrabacionEntity> call(int id) => _repo.detalle(id);
}

class ObtenerHistorialUseCase {
  final GrabacionRepository _repo;
  ObtenerHistorialUseCase(this._repo);

  Future<List<GrabacionEntity>> call() => _repo.historial();
}

class CalcularMetrosUseCase {
  final GrabacionRepository _repo;
  CalcularMetrosUseCase(this._repo);

  Future<CalculoEntity> call(
          {int? grabacionId,
          String? texto,
          double? altura,
          double? paredesM2}) =>
      _repo.calcular(
          grabacionId: grabacionId,
          texto: texto,
          altura: altura,
          paredesM2: paredesM2);
}

class ActualizarTranscripcionUseCase {
  final GrabacionRepository _repo;
  ActualizarTranscripcionUseCase(this._repo);

  Future<GrabacionEntity> call(int id, String texto) =>
      _repo.actualizarTranscripcion(id, texto);
}
