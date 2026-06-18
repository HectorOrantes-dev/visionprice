import 'package:equatable/equatable.dart';

/// Entidad User — capa Domain.
/// No depende de ningún framework externo.
class User extends Equatable {
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

  @override
  List<Object?> get props => [id, name, email, avatarUrl, isBiometricEnabled];
}
