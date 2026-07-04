import '../../domain/entities/notificacion_entity.dart';

abstract class NotificacionRemoteDataSource {
  Future<List<NotificacionEntity>> listar();
  Future<void> marcarLeida(int id);
}
