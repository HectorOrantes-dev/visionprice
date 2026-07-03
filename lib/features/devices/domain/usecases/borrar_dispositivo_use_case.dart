import 'package:injectable/injectable.dart';

import '../repositories/dispositivo_repository.dart';

/// Da de baja el device token (logout / cambio de sesión).
@injectable
class BorrarDispositivoUseCase {
  final DispositivoRepository _repo;
  BorrarDispositivoUseCase(this._repo);

  Future<void> call({required String token}) => _repo.borrar(token: token);
}
