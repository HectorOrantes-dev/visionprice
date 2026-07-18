import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../devices/data/providers/device_providers.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../domain/entities/role_entity.dart';
import 'auth_providers.dart';
import 'register_state.dart';

export 'register_state.dart';

part 'register_provider.g.dart';

/// Notifier del registro (Riverpod moderno). Reemplaza al `RegisterViewModel`
/// (ChangeNotifier). Carga los roles al construirse y reutiliza el use case de
/// verificación 2FA (mismo mecanismo que el login).
@riverpod
class Register extends _$Register with ValidationMixin {
  String _correo = '';

  @override
  RegisterState build() {
    // Carga inicial de roles (fire-and-forget: actualiza el state al terminar).
    loadRoles();
    return const RegisterState();
  }

  /// Carga los roles del back-end. Si falla, deja un rol por defecto para que
  /// la pantalla siga siendo usable.
  Future<void> loadRoles() async {
    try {
      final result = await ref.read(getRolesUseCaseProvider)();
      if (result.isNotEmpty) state = state.copyWith(roles: result);
    } catch (_) {
      state = state.copyWith(
        roles: const [RoleEntity(value: 'maestro_obra', label: 'Maestro obra')],
      );
    }
  }

  void toggleObscurePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);

  void selectRole(RoleEntity? role) =>
      state = state.copyWith(selectedRole: role, roleError: null);

  void onNameChanged(String value) {
    state = state.copyWith(
        nombreError: value.isEmpty ? null : validateName(value));
  }

  void onEmailChanged(String value) {
    state = state.copyWith(
        emailError: value.isEmpty ? null : validateEmail(value));
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(
        passwordError: value.isEmpty ? null : validatePassword(value));
  }

  /// Valida el formulario y registra. Si el back-end envió el código 2FA,
  /// pasa a [RegisterStatus.codeSent].
  Future<void> register({
    required String nombre,
    required String correo,
    required String contrasena,
    required String telefono,
  }) async {
    final nombreError = validateName(nombre);
    final emailError = validateEmail(correo);
    final passwordError = validatePassword(contrasena);
    final roleError = state.selectedRole == null ? 'Selecciona un rol' : null;
    if (nombreError != null ||
        emailError != null ||
        passwordError != null ||
        roleError != null) {
      state = state.copyWith(
        nombreError: nombreError,
        emailError: emailError,
        passwordError: passwordError,
        roleError: roleError,
      );
      return;
    }

    _correo = correo;
    state = state.copyWith(status: RegisterStatus.loading, errorMessage: null);
    try {
      final result = await ref.read(registerUseCaseProvider)(
        nombre: nombre,
        correo: correo,
        contrasena: contrasena,
        rol: state.selectedRole!.value,
        telefono: telefono,
      );
      state = state.copyWith(
        status: RegisterStatus.codeSent,
        errorMessage: result.message.isEmpty ? null : result.message,
      );
    } catch (e) {
      _fail(e);
    }
  }

  /// Paso 2: verifica el código y deja la sesión lista (token guardado).
  Future<void> verifyCode({
    required String code,
    required VoidCallback onSuccess,
  }) async {
    final codeError = validateCode(code);
    if (codeError != null) {
      state = state.copyWith(codeError: codeError);
      return;
    }

    state = state.copyWith(status: RegisterStatus.loading, errorMessage: null);
    try {
      await ref.read(verifyTwoFactorUseCaseProvider)(correo: _correo, code: code);
      state = state.copyWith(status: RegisterStatus.success);
      ref.read(deviceRegistrarProvider).register();
      onSuccess();
    } catch (e) {
      _fail(e);
    }
  }

  void _fail(Object error) {
    state = state.copyWith(
      status: RegisterStatus.error,
      errorMessage:
          error is ApiException ? error.message : 'Ocurrió un error inesperado',
    );
  }
}
