import '../../domain/entities/notificacion_entity.dart';
import '../../domain/repositories/notificacion_repository.dart';
import '../datasources/notificacion_remote_datasource.dart';

class NotificacionRepositoryImpl implements NotificacionRepository {
  final NotificacionRemoteDataSource _remote;
  NotificacionRepositoryImpl(this._remote);

  @override
  Future<List<NotificacionEntity>> listar({bool soloNoLeidas = false}) =>
      _remote.listar(soloNoLeidas);

  @override
  Future<void> marcarLeida(int id) => _remote.marcarLeida(id);
}
