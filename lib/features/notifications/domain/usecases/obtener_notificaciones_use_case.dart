import 'package:injectable/injectable.dart';

import '../entities/notificacion_entity.dart';
import '../repositories/notificacion_repository.dart';

/// Lista las notificaciones (opcionalmente solo las no leídas).
@injectable
class ObtenerNotificacionesUseCase {
  final NotificacionRepository _repo;
  ObtenerNotificacionesUseCase(this._repo);

  Future<List<NotificacionEntity>> call({bool soloNoLeidas = false}) =>
      _repo.listar(soloNoLeidas: soloNoLeidas);
}
