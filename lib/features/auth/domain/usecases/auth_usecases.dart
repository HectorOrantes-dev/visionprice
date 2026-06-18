import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: Iniciar sesión con email y contraseña.
@injectable
final class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) =>
      _repository.login(email: email, password: password);
}

/// Caso de uso: Registrar nuevo usuario.
@injectable
final class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    required String password,
  }) =>
      _repository.register(name: name, email: email, password: password);
}

/// Caso de uso: Cerrar sesión.
@injectable
final class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call() => _repository.logout();
}
