import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../../devices/data/services/device_registrar.dart';
import '../../domain/usecases/auth_usecases.dart';

/// Pasos del flujo de "¿Olvidaste tu contraseña?":
/// - [email] → pide el correo y envía el código.
/// - [code] → el usuario ingresa y verifica el código recibido.
/// - [password] → el usuario define su nueva contraseña.
enum ForgotStep { email, code, password }

@injectable
class ForgotPasswordViewModel extends ChangeNotifier with ValidationMixin {
  final ForgotPasswordUseCase _forgotUseCase;
  final VerifyResetCodeUseCase _verifyUseCase;
  final ResetPasswordUseCase _resetUseCase;
  final DeviceRegistrar _deviceRegistrar;

  ForgotPasswordViewModel(
    this._forgotUseCase,
    this._verifyUseCase,
    this._resetUseCase,
    this._deviceRegistrar,
  );

  ForgotStep _step = ForgotStep.email;
  bool _isLoading = false;
  String? _errorMessage;
  String _correo = '';
  String _resetToken = '';
  bool _sessionActive = false;
  bool _obscurePassword = true;

  String? emailError;
  String? codeError;
  String? passwordError;

  ForgotStep get step => _step;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;

  /// `true` si tras el reset el back-end devolvió sesión (auto-login) → la UI
  /// va directo al Home; `false` → cae al login manual (fallback).
  bool get sessionActive => _sessionActive;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void onEmailChanged(String value) {
    emailError = value.isEmpty ? null : validateEmail(value);
    notifyListeners();
  }

  void onCodeChanged(String value) {
    codeError = value.isEmpty ? null : validateCode(value);
    notifyListeners();
  }

  /// Vuelve al paso anterior sin perder los datos ya capturados.
  void volverAtras() {
    _errorMessage = null;
    if (_step == ForgotStep.password) {
      _step = ForgotStep.code;
    } else if (_step == ForgotStep.code) {
      _step = ForgotStep.email;
    }
    notifyListeners();
  }

  /// Paso 1: envía el código de recuperación al correo. Por anti-enumeración
  /// el back-end responde igual exista o no el correo. Al terminar, avanza al
  /// paso de verificación de código.
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
      _isLoading = false;
      _step = ForgotStep.code;
      notifyListeners();
    } catch (e) {
      _fail(e);
    }
  }

  /// Paso 2: verifica el código contra el back-end. Si es válido, guarda el
  /// `reset_token` recibido y avanza al paso de nueva contraseña.
  Future<void> verificarCodigo({required String code}) async {
    codeError = validateCode(code);
    if (codeError != null) {
      notifyListeners();
      return;
    }
    _setLoading();
    try {
      _resetToken = await _verifyUseCase(correo: _correo, code: code);
      _isLoading = false;
      _step = ForgotStep.password;
      notifyListeners();
    } catch (e) {
      _fail(e);
    }
  }

  /// Paso 3: establece la nueva contraseña usando el `reset_token` verificado.
  /// El back-end responde con la sesión iniciada → guarda el token (en el
  /// repositorio) y marca [sessionActive] para que la UI vaya directo al Home.
  Future<void> restablecer({
    required String nuevaContrasena,
    required VoidCallback onSuccess,
  }) async {
    passwordError = validatePassword(nuevaContrasena);
    if (passwordError != null) {
      notifyListeners();
      return;
    }
    _setLoading();
    try {
      final session = await _resetUseCase(
        correo: _correo,
        resetToken: _resetToken,
        nuevaContrasena: nuevaContrasena,
      );
      _sessionActive = session != null;
      _isLoading = false;
      notifyListeners();
      // Registra el device token para push (best-effort) si quedó logueado.
      if (_sessionActive) _deviceRegistrar.register();
      onSuccess();
    } catch (e) {
      _fail(e);
    }
  }

  void _setLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _fail(Object error) {
    _isLoading = false;
    _errorMessage =
        error is ApiException ? error.message : 'Ocurrió un error inesperado';
    notifyListeners();
  }
}
