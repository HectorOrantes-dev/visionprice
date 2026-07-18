import '../../domain/entities/role_entity.dart';

/// Estado inmutable del registro (refleja al del login).
enum RegisterStatus { idle, loading, codeSent, success, error }

class RegisterState {
  final RegisterStatus status;
  final String? errorMessage;
  final String? nombreError;
  final String? emailError;
  final String? passwordError;
  final String? roleError;
  final String? codeError;
  final bool obscurePassword;
  final List<RoleEntity> roles;
  final RoleEntity? selectedRole;

  const RegisterState({
    this.status = RegisterStatus.idle,
    this.errorMessage,
    this.nombreError,
    this.emailError,
    this.passwordError,
    this.roleError,
    this.codeError,
    this.obscurePassword = true,
    this.roles = const [],
    this.selectedRole,
  });

  bool get isLoading => status == RegisterStatus.loading;
  bool get requiresTwoFactor => status == RegisterStatus.codeSent;

  static const _keep = Object();

  RegisterState copyWith({
    RegisterStatus? status,
    Object? errorMessage = _keep,
    Object? nombreError = _keep,
    Object? emailError = _keep,
    Object? passwordError = _keep,
    Object? roleError = _keep,
    Object? codeError = _keep,
    bool? obscurePassword,
    List<RoleEntity>? roles,
    Object? selectedRole = _keep,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      nombreError:
          nombreError == _keep ? this.nombreError : nombreError as String?,
      emailError: emailError == _keep ? this.emailError : emailError as String?,
      passwordError: passwordError == _keep
          ? this.passwordError
          : passwordError as String?,
      roleError: roleError == _keep ? this.roleError : roleError as String?,
      codeError: codeError == _keep ? this.codeError : codeError as String?,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      roles: roles ?? this.roles,
      selectedRole: selectedRole == _keep
          ? this.selectedRole
          : selectedRole as RoleEntity?,
    );
  }
}
