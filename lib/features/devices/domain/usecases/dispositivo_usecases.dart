import 'package:injectable/injectable.dart';

import '../repositories/dispositivo_repository.dart';

@injectable
class RegistrarDispositivoUseCase {
  final DispositivoRepository _repo;
  RegistrarDispositivoUseCase(this._repo);

  Future<void> call({required String token, required String plataforma}) =>
      _repo.registrar(token: token, plataforma: plataforma);
}

@injectable
class BorrarDispositivoUseCase {
  final DispositivoRepository _repo;
  BorrarDispositivoUseCase(this._repo);

  Future<void> call({required String token}) => _repo.borrar(token: token);
}
