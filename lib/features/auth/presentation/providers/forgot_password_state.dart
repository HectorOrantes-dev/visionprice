/// Pasos del flujo de "¿Olvidaste tu contraseña?":
/// - [email] → pide el correo y envía el código.
/// - [code] → el usuario ingresa y verifica el código recibido.
/// - [password] → el usuario define su nueva contraseña.
enum ForgotStep { email, code, password }

/// Estado inmutable del flujo de recuperación de contraseña.
class ForgotPasswordState {
  final ForgotStep step;
  final bool isLoading;
  final String? errorMessage;
  final String? emailError;
  final String? codeError;
  final String? passwordError;

  /// `true` si tras el reset el back-end devolvió sesión (auto-login) → la UI
  /// va directo al Home; `false` → cae al login manual (fallback).
  final bool sessionActive;
  final bool obscurePassword;

  const ForgotPasswordState({
    this.step = ForgotStep.email,
    this.isLoading = false,
    this.errorMessage,
    this.emailError,
    this.codeError,
    this.passwordError,
    this.sessionActive = false,
    this.obscurePassword = true,
  });

  static const _keep = Object();

  ForgotPasswordState copyWith({
    ForgotStep? step,
    bool? isLoading,
    Object? errorMessage = _keep,
    Object? emailError = _keep,
    Object? codeError = _keep,
    Object? passwordError = _keep,
    bool? sessionActive,
    bool? obscurePassword,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      emailError: emailError == _keep ? this.emailError : emailError as String?,
      codeError: codeError == _keep ? this.codeError : codeError as String?,
      passwordError: passwordError == _keep
          ? this.passwordError
          : passwordError as String?,
      sessionActive: sessionActive ?? this.sessionActive,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}
