import 'package:injectable/injectable.dart';

import '../entities/grabacion_entity.dart';
import '../repositories/grabacion_repository.dart';

/// Historial de grabaciones del usuario.
@injectable
class ObtenerHistorialUseCase {
  final GrabacionRepository _repo;
  ObtenerHistorialUseCase(this._repo);

  Future<List<GrabacionEntity>> call() => _repo.historial();
}
