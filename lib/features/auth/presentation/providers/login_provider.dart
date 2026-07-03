import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../../devices/data/services/device_registrar.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'login_state.dart';

// El enum de estado vive en su propio archivo (SRP); se re-exporta para que
// las pantallas que importan este provider sigan viendo `LoginState`.
export 'login_state.dart';

/// ViewModel del login. `@injectable` (factory): `getIt<LoginViewModel>()`
/// crea una instancia nueva por pantalla, con sus use cases ya inyectados.
///
/// Usa [ValidationMixin] para la validación de formularios (sin duplicar).
@injectable
class LoginViewModel extends ChangeNotifier with ValidationMixin {
  final LoginUseCase _loginUseCase;
  final VerifyTwoFactorUseCase _verifyUseCase;
  final GoogleLoginUseCase _googleLoginUseCase;
  final DeviceRegistrar _deviceRegistrar;

  LoginViewModel(
    this._loginUseCase,
    this._verifyUseCase,
    this._googleLoginUseCase,
    this._deviceRegistrar,
  );

  LoginState _state = LoginState.idle;
  String? _errorMessage;
  String _correo = '';
  bool _keepSession = true;
  bool _obscurePassword = true;

  String? emailError;
  String? passwordError;
  String? codeError;

  LoginState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get keepSession => _keepSession;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _state == LoginState.loading;
  bool get requiresTwoFactor => _state == LoginState.codeSent;

  void toggleKeepSession() {
    _keepSession = !_keepSession;
    notifyListeners();
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void onEmailChanged(String value) {
    emailError = value.isEmpty ? null : validateEmail(value);
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    passwordError = value.isEmpty ? null : validatePassword(value);
    notifyListeners();
  }

  /// Paso 1: valida y dispara el envío del código 2FA al correo.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emailError = validateEmail(email);
    passwordError = validatePassword(password);
    if (emailError != null || passwordError != null) {
      notifyListeners();
      return;
    }

    _correo = email;
    _setLoading();
    try {
      await _loginUseCase(correo: email, contrasena: password);
      _state = LoginState.codeSent;
      notifyListeners();
    } catch (e) {
      _fail(e);
    }
  }

  /// Paso 2: verifica el código y, si es correcto, deja la sesión lista.
  Future<void> verifyCode({
    required String code,
    required VoidCallback onSuccess,
  }) async {
    codeError = validateCode(code);
    if (codeError != null) {
      notifyListeners();
      return;
    }

    _setLoading();
    try {
      await _verifyUseCase(correo: _correo, code: code);
      _state = LoginState.success;
      notifyListeners();
      // Registra el device token para push (best-effort, no bloquea).
      _deviceRegistrar.register();
      onSuccess();
    } catch (e) {
      _fail(e);
    }
  }

  /// Login con Google. Lanza al callback [onNeedsRegister] si el back-end
  /// responde 404 (usuario no registrado con Google).
  Future<void> loginWithGoogle({
    required String idToken,
    required VoidCallback onSuccess,
    required VoidCallback onNeedsRegister,
  }) async {
    _setLoading();
    try {
      await _googleLoginUseCase(idToken: idToken);
      _state = LoginState.success;
      notifyListeners();
      _deviceRegistrar.register();
      onSuccess();
    } on ApiException catch (e) {
      if (e.isNotFound) {
        _state = LoginState.idle;
        notifyListeners();
        onNeedsRegister();
      } else {
        _fail(e);
      }
    } catch (e) {
      _fail(e);
    }
  }

  void reset() {
    _state = LoginState.idle;
    _errorMessage = null;
    emailError = null;
    passwordError = null;
    codeError = null;
    notifyListeners();
  }

  void _setLoading() {
    _state = LoginState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _fail(Object error) {
    _state = LoginState.error;
    _errorMessage =
        error is ApiException ? error.message : 'Ocurrió un error inesperado';
    notifyListeners();
  }
}
