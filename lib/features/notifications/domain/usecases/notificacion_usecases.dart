
import '../entities/notificacion_entity.dart';
import '../repositories/notificacion_repository.dart';

class ObtenerNotificacionesUseCase {
  final NotificacionRepository _repo;
  ObtenerNotificacionesUseCase(this._repo);

  Future<List<NotificacionEntity>> call({bool soloNoLeidas = false}) =>
      _repo.listar(soloNoLeidas: soloNoLeidas);
}

class MarcarNotificacionLeidaUseCase {
  final NotificacionRepository _repo;
  MarcarNotificacionLeidaUseCase(this._repo);

  Future<void> call(int id) => _repo.marcarLeida(id);
}
