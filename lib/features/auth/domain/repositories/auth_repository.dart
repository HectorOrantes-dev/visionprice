import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Contrato del repositorio de autenticación — capa Domain.
abstract interface class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithBiometrics();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> enableBiometrics();

  Future<User?> getCurrentUser();
}
