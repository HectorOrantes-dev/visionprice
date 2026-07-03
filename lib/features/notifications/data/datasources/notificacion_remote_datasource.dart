import '../../domain/entities/notificacion_entity.dart';

// La implementación vive en su propio archivo (una clase por archivo, SRP);
// se re-exporta para no romper imports existentes ni la DI generada.
export 'notificacion_remote_datasource_impl.dart';

abstract class NotificacionRemoteDataSource {
  Future<List<NotificacionEntity>> listar(bool soloNoLeidas);
  Future<void> marcarLeida(int id);
}
