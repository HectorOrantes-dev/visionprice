import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../../devices/data/services/device_registrar.dart';
import '../../domain/entities/role_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'register_state.dart';

// El enum de estado vive en su propio archivo (SRP); se re-exporta para que
// las pantallas que importan este provider sigan viendo `RegisterState`.
export 'register_state.dart';

/// ViewModel del registro. `@injectable` (factory). Carga los roles al crearse
/// y reutiliza [VerifyTwoFactorUseCase] para el paso 2FA (mismo mecanismo que
/// el login). Usa [ValidationMixin] para validar el formulario.
@injectable
class RegisterViewModel extends ChangeNotifier with ValidationMixin {
  final RegisterUseCase _registerUseCase;
  final VerifyTwoFactorUseCase _verifyUseCase;
  final GetRolesUseCase _getRolesUseCase;
  final DeviceRegistrar _deviceRegistrar;

  RegisterViewModel(
    this._registerUseCase,
    this._verifyUseCase,
    this._getRolesUseCase,
    this._deviceRegistrar,
  ) {
    loadRoles();
  }

  RegisterState _state = RegisterState.idle;
  String? _errorMessage;
  String _correo = '';
  bool _obscurePassword = true;

  List<RoleEntity> _roles = const [];
  RoleEntity? _selectedRole;

  String? nombreError;
  String? emailError;
  String? passwordError;
  String? roleError;
  String? codeError;

  RegisterState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _state == RegisterState.loading;
  bool get requiresTwoFactor => _state == RegisterState.codeSent;
  List<RoleEntity> get roles => _roles;
  RoleEntity? get selectedRole => _selectedRole;

  /// Carga los roles del back-end. Si falla, deja un rol por defecto para que
  /// la pantalla siga siendo usable.
  Future<void> loadRoles() async {
    try {
      final result = await _getRolesUseCase();
      if (result.isNotEmpty) _roles = result;
    } catch (_) {
      _roles = const [RoleEntity(value: 'maestro_obra', label: 'Maestro obra')];
    }
    notifyListeners();
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void selectRole(RoleEntity? role) {
    _selectedRole = role;
    roleError = null;
    notifyListeners();
  }

  void onNameChanged(String value) {
    nombreError = value.isEmpty ? null : validateName(value);
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

  /// Valida el formulario y registra. Si el back-end envió el código 2FA,
  /// pasa a [RegisterState.codeSent].
  Future<void> register({
    required String nombre,
    required String correo,
    required String contrasena,
    required String telefono,
  }) async {
    nombreError = validateName(nombre);
    emailError = validateEmail(correo);
    passwordError = validatePassword(contrasena);
    roleError = _selectedRole == null ? 'Selecciona un rol' : null;
    if (nombreError != null ||
        emailError != null ||
        passwordError != null ||
        roleError != null) {
      notifyListeners();
      return;
    }

    _correo = correo;
    _setLoading();
    try {
      final result = await _registerUseCase(
        nombre: nombre,
        correo: correo,
        contrasena: contrasena,
        rol: _selectedRole!.value,
        telefono: telefono,
      );
      _state = RegisterState.codeSent;
      _errorMessage = result.message.isEmpty ? null : result.message;
      notifyListeners();
    } catch (e) {
      _fail(e);
    }
  }

  /// Paso 2: verifica el código y deja la sesión lista (token guardado).
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
      _state = RegisterState.success;
      notifyListeners();
      _deviceRegistrar.register();
      onSuccess();
    } catch (e) {
      _fail(e);
    }
  }

  void _setLoading() {
    _state = RegisterState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _fail(Object error) {
    _state = RegisterState.error;
    _errorMessage =
        error is ApiException ? error.message : 'Ocurrió un error inesperado';
    notifyListeners();
  }
}
