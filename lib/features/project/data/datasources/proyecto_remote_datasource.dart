import '../../domain/entities/proyecto_entity.dart';

abstract class ProyectoRemoteDataSource {
  Future<List<ProyectoEntity>> listar();
  Future<ProyectoEntity> crear(String nombre, {String? direccion});
}
