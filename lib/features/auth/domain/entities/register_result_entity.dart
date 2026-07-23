import 'user_entity.dart';

/// Resultado del registro. El back-end responde
/// `{usuario, two_factor_sent, message}`: si `twoFactorSent` es `true`, mandó
/// un código 2FA al correo y hay que verificarlo para completar el acceso.
class RegisterResultEntity {
  final UserEntity? user;
  final bool twoFactorSent;
  final String message;

  const RegisterResultEntity({
    this.user,
    required this.twoFactorSent,
    this.message = '',
  });

  factory RegisterResultEntity.fromJson(Map<String, dynamic> json) {
    final usuario = json['usuario'] ?? json['user'];
    return RegisterResultEntity(
      user:
          usuario is Map<String, dynamic> ? UserEntity.fromJson(usuario) : null,
      twoFactorSent: json['two_factor_sent'] == true,
      message: (json['message'] ?? '').toString(),
    );
  }
}
