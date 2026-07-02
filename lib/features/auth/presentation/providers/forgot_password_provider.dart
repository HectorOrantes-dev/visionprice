import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../domain/usecases/auth_usecases.dart';

/// Flujo de "¿Olvidaste tu contraseña?":
/// - [idle] → pide el correo.
/// - [loading] → petición en curso.
/// - [codeSent] → el back-end envió el código (paso 1 ok).
/// - [success] → contraseña actualizada.
/// - [error] → ver [errorMessage].
enum ForgotState { idle, loading, codeSent, success, error }

@injectable
class ForgotPasswordViewModel extends ChangeNotifier with ValidationMixin {
  final ForgotPasswordUseCase _forgotUseCase;
  final ResetPasswordUseCase _resetUseCase;

  ForgotPasswordViewModel(this._forgotUseCase, this._resetUseCase);

  ForgotState _state = ForgotState.idle;
  String? _errorMessage;
  String _correo = '';
  bool _obscurePassword = true;

  String? emailError;
  String? codeError;
  String? passwordError;

  ForgotState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ForgotState.loading;
  bool get codeSent => _state == ForgotState.codeSent;
  bool get obscurePassword => _obscurePassword;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void onEmailChanged(String value) {
    emailError = value.isEmpty ? null : validateEmail(value);
    notifyListeners();
  }

  /// Paso 1: envía el código de recuperación al correo. Por anti-enumeración
  /// el back-end responde igual exista o no el correo.
  Future<void> enviarCodigo({required String correo}) async {
    emailError = validateEmail(correo);
    if (emailError != null) {
      notifyListeners();
      return;
    }
    _correo = correo;
    _setLoading();
    try {
      await _forgotUseCase(correo: correo);
      _state = ForgotState.codeSent;
      notifyListeners();
    } catch (e) {
      _fail(e);
    }
  }

  /// Paso 2: verifica el código y establece la nueva contraseña.
  Future<void> restablecer({
    required String code,
    required String nuevaContrasena,
    required VoidCallback onSuccess,
  }) async {
    codeError = validateCode(code);
    passwordError = validatePassword(nuevaContrasena);
    if (codeError != null || passwordError != null) {
      notifyListeners();
      return;
    }
    _setLoading();
    try {
      await _resetUseCase(
        correo: _correo,
        code: code,
        nuevaContrasena: nuevaContrasena,
      );
      _state = ForgotState.success;
      notifyListeners();
      onSuccess();
    } catch (e) {
      _fail(e);
    }
  }

  void _setLoading() {
    _state = ForgotState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _fail(Object error) {
    _state = ForgotState.error;
    _errorMessage =
        error is ApiException ? error.message : 'Ocurrió un error inesperado';
    notifyListeners();
  }
}
