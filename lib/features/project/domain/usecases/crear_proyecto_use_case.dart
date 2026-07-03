import 'package:injectable/injectable.dart';

import '../entities/proyecto_entity.dart';
import '../repositories/proyecto_repository.dart';

/// Crea un proyecto nuevo.
@injectable
class CrearProyectoUseCase {
  final ProyectoRepository _repo;
  CrearProyectoUseCase(this._repo);

  Future<ProyectoEntity> call({required String nombre, String? direccion}) =>
      _repo.crear(nombre: nombre, direccion: direccion);
}
