import 'package:injectable/injectable.dart';

import '../entities/register_result_entity.dart';
import '../repositories/auth_repository.dart';

/// Registro con correo/contraseña. Devuelve el resultado (usuario + 2FA).
@injectable
class RegisterUseCase {
  final AuthRepository _repo;
  RegisterUseCase(this._repo);

  Future<RegisterResultEntity> call({
    required String nombre,
    required String correo,
    required String contrasena,
    required String rol,
    String? telefono,
  }) =>
      _repo.register(
        nombre: nombre,
        correo: correo,
        contrasena: contrasena,
        rol: rol,
        telefono: telefono,
      );
}
