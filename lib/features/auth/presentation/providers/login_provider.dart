import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../devices/data/providers/device_providers.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/validation_mixin.dart';
import 'auth_providers.dart';
import 'login_state.dart';

export 'login_state.dart';

part 'login_provider.g.dart';

/// Notifier del login (enfoque moderno de Riverpod). Reemplaza al antiguo
/// `LoginViewModel` (ChangeNotifier). El estado vive en [LoginState] inmutable;
/// las dependencias (use cases, device registrar) se resuelven vía `ref`.
///
/// Usa [ValidationMixin] para la validación de formularios (sin duplicar).
@riverpod
class Login extends _$Login with ValidationMixin {
  String _correo = '';

  @override
  LoginState build() => const LoginState();

  void toggleKeepSession() =>
      state = state.copyWith(keepSession: !state.keepSession);

  void toggleObscurePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);

  void onEmailChanged(String value) {
    state = state.copyWith(
        emailError: value.isEmpty ? null : validateEmail(value));
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(
        passwordError: value.isEmpty ? null : validatePassword(value));
  }

  /// Paso 1: valida y hace login. Si el back-end responde con token (2FA
  /// desactivado), inicia sesión directo y llama a [onSuccess]. Si en su lugar
  /// envió un código, pasa al paso de verificación (2FA).
  Future<void> login({
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);
    if (emailError != null || passwordError != null) {
      state = state.copyWith(
          emailError: emailError, passwordError: passwordError);
      return;
    }

    _correo = email;
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);
    try {
      final session = await ref.read(loginUseCaseProvider)(
        correo: email,
        contrasena: password,
      );
      if (session != null) {
        // Login directo: no hace falta código de verificación.
        state = state.copyWith(status: LoginStatus.success);
        ref.read(deviceRegistrarProvider).register();
        onSuccess();
      } else {
        state = state.copyWith(status: LoginStatus.codeSent);
      }
    } catch (e) {
      _fail(e);
    }
  }

  /// Paso 2: verifica el código y, si es correcto, deja la sesión lista.
  Future<void> verifyCode({
    required String code,
    required VoidCallback onSuccess,
  }) async {
    final codeError = validateCode(code);
    if (codeError != null) {
      state = state.copyWith(codeError: codeError);
      return;
    }

    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);
    try {
      await ref.read(verifyTwoFactorUseCaseProvider)(
        correo: _correo,
        code: code,
      );
      state = state.copyWith(status: LoginStatus.success);
      ref.read(deviceRegistrarProvider).register();
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
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);
    try {
      await ref.read(googleLoginUseCaseProvider)(idToken: idToken);
      state = state.copyWith(status: LoginStatus.success);
      ref.read(deviceRegistrarProvider).register();
      onSuccess();
    } on ApiException catch (e) {
      if (e.isNotFound) {
        state = state.copyWith(status: LoginStatus.idle);
        onNeedsRegister();
      } else {
        _fail(e);
      }
    } catch (e) {
      _fail(e);
    }
  }

  /// Registro con Google cuando `loginWithGoogle` avisó que el usuario no
  /// existe aún (`onNeedsRegister`): ya con el rol elegido, crea la cuenta.
  Future<void> registerWithGoogle({
    required String idToken,
    required String rol,
    required VoidCallback onSuccess,
  }) async {
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);
    try {
      await ref.read(googleRegisterUseCaseProvider)(idToken: idToken, rol: rol);
      state = state.copyWith(status: LoginStatus.success);
      ref.read(deviceRegistrarProvider).register();
      onSuccess();
    } catch (e) {
      _fail(e);
    }
  }

  void _fail(Object error) {
    state = state.copyWith(
      status: LoginStatus.error,
      errorMessage:
          error is ApiException ? error.message : 'Ocurrió un error inesperado',
    );
  }
}
