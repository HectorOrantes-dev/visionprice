import '../repositories/notificacion_repository.dart';

/// Marca una notificación como leída.
class MarcarNotificacionLeidaUseCase {
  final NotificacionRepository _repo;
  MarcarNotificacionLeidaUseCase(this._repo);

  Future<void> call(int id) => _repo.marcarLeida(id);
}
