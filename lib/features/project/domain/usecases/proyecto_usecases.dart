import '../entities/proyecto_entity.dart';
import '../repositories/proyecto_repository.dart';

class ObtenerProyectosUseCase {
  final ProyectoRepository _repo;
  ObtenerProyectosUseCase(this._repo);

  Future<List<ProyectoEntity>> call() => _repo.listar();
}

class CrearProyectoUseCase {
  final ProyectoRepository _repo;
  CrearProyectoUseCase(this._repo);

  Future<ProyectoEntity> call({
    required String nombre,
    String? direccion,
    double? latitud,
    double? longitud,
  }) =>
      _repo.crear(
        nombre: nombre,
        direccion: direccion,
        latitud: latitud,
        longitud: longitud,
      );
}

/// Completa la ubicación de una obra creada sin coordenadas
/// (`PATCH /api/v1/proyectos/{id}`), para que entre al dataset de entrenamiento.
class ActualizarUbicacionProyectoUseCase {
  final ProyectoRepository _repo;
  ActualizarUbicacionProyectoUseCase(this._repo);

  Future<ProyectoEntity> call({
    required int id,
    required double latitud,
    required double longitud,
  }) =>
      _repo.actualizarUbicacion(id: id, latitud: latitud, longitud: longitud);
}
