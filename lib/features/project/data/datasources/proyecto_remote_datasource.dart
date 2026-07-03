import '../../domain/entities/proyecto_entity.dart';

// La implementación vive en su propio archivo (una clase por archivo, SRP);
// se re-exporta para no romper imports existentes ni la DI generada.
export 'proyecto_remote_datasource_impl.dart';

abstract class ProyectoRemoteDataSource {
  Future<List<ProyectoEntity>> listar();
  Future<ProyectoEntity> crear(String nombre, {String? direccion});
}
