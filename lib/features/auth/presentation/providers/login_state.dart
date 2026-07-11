/// Estado inmutable del login. Se reemplaza por completo en cada cambio (norma
/// de Riverpod), lo que elimina la clase de bugs de `notifyListeners` olvidado.
enum LoginStatus { idle, loading, codeSent, success, error }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;
  final String? emailError;
  final String? passwordError;
  final String? codeError;
  final bool keepSession;
  final bool obscurePassword;

  const LoginState({
    this.status = LoginStatus.idle,
    this.errorMessage,
    this.emailError,
    this.passwordError,
    this.codeError,
    this.keepSession = true,
    this.obscurePassword = true,
  });

  bool get isLoading => status == LoginStatus.loading;
  bool get requiresTwoFactor => status == LoginStatus.codeSent;

  static const _keep = Object();

  LoginState copyWith({
    LoginStatus? status,
    Object? errorMessage = _keep,
    Object? emailError = _keep,
    Object? passwordError = _keep,
    Object? codeError = _keep,
    bool? keepSession,
    bool? obscurePassword,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      emailError: emailError == _keep ? this.emailError : emailError as String?,
      passwordError: passwordError == _keep
          ? this.passwordError
          : passwordError as String?,
      codeError: codeError == _keep ? this.codeError : codeError as String?,
      keepSession: keepSession ?? this.keepSession,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}
