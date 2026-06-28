import 'package:equatable/equatable.dart';

/// Entidad User — capa Domain.
/// No depende de ningún framework externo.
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.token,
    this.isBiometricEnabled = false,
  });

  final String id;
  final String name;
  final String email;

  /// Rol del usuario: 'maestro_obra' | 'contratista' | 'arquitecto' | 'ingeniero_civil'
  final String role;

  final String? avatarUrl;

  /// JWT token de sesión (opcional, manejado por SecureStorage en prod)
  final String? token;

  final bool isBiometricEnabled;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    String? token,
    bool? isBiometricEnabled,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      token: token ?? this.token,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, email, role, avatarUrl, token, isBiometricEnabled];
}
