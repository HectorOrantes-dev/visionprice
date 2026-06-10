import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

/// Entidad User — capa Domain
final class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isBiometricEnabled = false,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isBiometricEnabled;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    bool? isBiometricEnabled,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}

/// Contrato de repositorio de autenticación
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
