import 'package:injectable/injectable.dart';

import '../entities/proyecto_entity.dart';
import '../repositories/proyecto_repository.dart';

@injectable
class ObtenerProyectosUseCase {
  final ProyectoRepository _repo;
  ObtenerProyectosUseCase(this._repo);

  Future<List<ProyectoEntity>> call() => _repo.listar();
}

@injectable
class CrearProyectoUseCase {
  final ProyectoRepository _repo;
  CrearProyectoUseCase(this._repo);

  Future<ProyectoEntity> call({required String nombre, String? direccion}) =>
      _repo.crear(nombre: nombre, direccion: direccion);
}
