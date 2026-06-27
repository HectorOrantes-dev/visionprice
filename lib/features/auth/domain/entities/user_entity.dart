/// Usuario del dominio. Incluye su propio `fromJson` (sin un DTO/model aparte):
/// parseo defensivo que acepta claves en español o inglés.
class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['nombre'] ?? json['name'] ?? '').toString(),
      email: (json['correo'] ?? json['email'] ?? '').toString(),
      role: (json['rol'] ?? json['role'] ?? '').toString(),
      token: json['access_token']?.toString(),
    );
  }
}
