
import '../entities/proyecto_entity.dart';
import '../repositories/proyecto_repository.dart';

/// Lista los proyectos del usuario.
class ObtenerProyectosUseCase {
  final ProyectoRepository _repo;
  ObtenerProyectosUseCase(this._repo);

  Future<List<ProyectoEntity>> call() => _repo.listar();
}
