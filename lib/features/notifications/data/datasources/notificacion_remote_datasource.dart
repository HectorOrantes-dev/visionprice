import '../../domain/entities/notificacion_entity.dart';

abstract class NotificacionRemoteDataSource {
  Future<List<NotificacionEntity>> listar(bool soloNoLeidas);
  Future<void> marcarLeida(int id);
}
