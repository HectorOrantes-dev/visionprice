import '../../domain/entities/user.dart';

/// Modelo DTO de User — capa Data con serialización JSON.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.isBiometricEnabled,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      isBiometricEnabled: json['is_biometric_enabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar_url': avatarUrl,
        'is_biometric_enabled': isBiometricEnabled,
      };

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      isBiometricEnabled: entity.isBiometricEnabled,
    );
  }
}
