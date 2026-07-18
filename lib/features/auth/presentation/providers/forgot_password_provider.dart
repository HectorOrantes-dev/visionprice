import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../devices/data/providers/device_providers.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/validation_mixin.dart';
import 'auth_providers.dart';
import 'forgot_password_state.dart';

export 'forgot_password_state.dart';

part 'forgot_password_provider.g.dart';

/// Notifier del flujo "¿Olvidaste tu contraseña?" (Riverpod moderno). Reemplaza
/// al antiguo `ForgotPasswordViewModel` (ChangeNotifier). Estado inmutable en
/// [ForgotPasswordState]; dependencias resueltas vía `ref`.
@riverpod
class ForgotPassword extends _$ForgotPassword with ValidationMixin {
  String _correo = '';
  String _resetToken = '';

  @override
  ForgotPasswordState build() => const ForgotPasswordState();

  void toggleObscurePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);

  void onEmailChanged(String value) {
    state = state.copyWith(
        emailError: value.isEmpty ? null : validateEmail(value));
  }

  void onCodeChanged(String value) {
    state = state.copyWith(
        codeError: value.isEmpty ? null : validateCode(value));
  }

  /// Vuelve al paso anterior sin perder los datos ya capturados.
  void volverAtras() {
    if (state.step == ForgotStep.password) {
      state = state.copyWith(step: ForgotStep.code, errorMessage: null);
    } else if (state.step == ForgotStep.code) {
      state = state.copyWith(step: ForgotStep.email, errorMessage: null);
    }
  }

  /// Paso 1: envía el código de recuperación al correo. Por anti-enumeración
  /// el back-end responde igual exista o no el correo. Al terminar, avanza al
  /// paso de verificación de código.
  Future<void> enviarCodigo({required String correo}) async {
    final emailError = validateEmail(correo);
    if (emailError != null) {
      state = state.copyWith(emailError: emailError);
      return;
    }
    _correo = correo;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(forgotPasswordUseCaseProvider)(correo: correo);
      state = state.copyWith(isLoading: false, step: ForgotStep.code);
    } catch (e) {
      _fail(e);
    }
  }

  /// Paso 2: verifica el código contra el back-end. Si es válido, guarda el
  /// `reset_token` recibido y avanza al paso de nueva contraseña.
  Future<void> verificarCodigo({required String code}) async {
    final codeError = validateCode(code);
    if (codeError != null) {
      state = state.copyWith(codeError: codeError);
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      _resetToken =
          await ref.read(verifyResetCodeUseCaseProvider)(correo: _correo, code: code);
      state = state.copyWith(isLoading: false, step: ForgotStep.password);
    } catch (e) {
      _fail(e);
    }
  }

  /// Paso 3: establece la nueva contraseña usando el `reset_token` verificado.
  /// El back-end responde con la sesión iniciada → guarda el token (en el
  /// repositorio) y marca [ForgotPasswordState.sessionActive] para ir al Home.
  Future<void> restablecer({
    required String nuevaContrasena,
    required VoidCallback onSuccess,
  }) async {
    final passwordError = validatePassword(nuevaContrasena);
    if (passwordError != null) {
      state = state.copyWith(passwordError: passwordError);
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final session = await ref.read(resetPasswordUseCaseProvider)(
        correo: _correo,
        resetToken: _resetToken,
        nuevaContrasena: nuevaContrasena,
      );
      final sessionActive = session != null;
      state = state.copyWith(isLoading: false, sessionActive: sessionActive);
      // Registra el device token para push (best-effort) si quedó logueado.
      if (sessionActive) ref.read(deviceRegistrarProvider).register();
      onSuccess();
    } catch (e) {
      _fail(e);
    }
  }

  void _fail(Object error) {
    state = state.copyWith(
      isLoading: false,
      errorMessage:
          error is ApiException ? error.message : 'Ocurrió un error inesperado',
    );
  }
}
