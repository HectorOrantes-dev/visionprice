import 'package:injectable/injectable.dart';

import '../repositories/dispositivo_repository.dart';

/// Registra el device token (FCM) para push.
@injectable
class RegistrarDispositivoUseCase {
  final DispositivoRepository _repo;
  RegistrarDispositivoUseCase(this._repo);

  Future<void> call({required String token, required String plataforma}) =>
      _repo.registrar(token: token, plataforma: plataforma);
}
