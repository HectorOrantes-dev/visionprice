import '../entities/proyecto_entity.dart';

abstract class ProyectoRepository {
  Future<List<ProyectoEntity>> listar();
  Future<ProyectoEntity> crear({required String nombre, String? direccion});
}
