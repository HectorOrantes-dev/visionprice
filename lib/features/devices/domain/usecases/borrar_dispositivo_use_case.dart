import '../repositories/dispositivo_repository.dart';

/// Da de baja el device token (logout / cambio de sesión).
class BorrarDispositivoUseCase {
  final DispositivoRepository _repo;
  BorrarDispositivoUseCase(this._repo);

  Future<void> call({required String token}) => _repo.borrar(token: token);
}
