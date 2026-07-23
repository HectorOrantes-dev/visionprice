import '../repositories/dispositivo_repository.dart';

class RegistrarDispositivoUseCase {
  final DispositivoRepository _repo;
  RegistrarDispositivoUseCase(this._repo);

  Future<void> call({required String token, required String plataforma}) =>
      _repo.registrar(token: token, plataforma: plataforma);
}

class BorrarDispositivoUseCase {
  final DispositivoRepository _repo;
  BorrarDispositivoUseCase(this._repo);

  Future<void> call({required String token}) => _repo.borrar(token: token);
}
