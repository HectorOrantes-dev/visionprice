import 'user_entity.dart';

/// Sesión autenticada: el `access_token` que devuelve el back-end tras
/// `login/verify` o `google/*`, y opcionalmente el usuario asociado.
/// Lleva su propio `fromJson` (sin DTO/model separado).
class AuthSessionEntity {
  final String accessToken;
  final String tokenType;
  final UserEntity? user;

  const AuthSessionEntity({
    required this.accessToken,
    this.tokenType = 'Bearer',
    this.user,
  });

  factory AuthSessionEntity.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? json['usuario'];
    return AuthSessionEntity(
      accessToken: (json['access_token'] ?? json['token'] ?? '').toString(),
      tokenType: (json['token_type'] ?? 'Bearer').toString(),
      user: userJson is Map<String, dynamic>
          ? UserEntity.fromJson(userJson)
          : null,
    );
  }
}
