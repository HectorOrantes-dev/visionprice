import '../entities/notificacion_entity.dart';

abstract class NotificacionRepository {
  Future<List<NotificacionEntity>> listar({bool soloNoLeidas = false});
  Future<void> marcarLeida(int id);
}
