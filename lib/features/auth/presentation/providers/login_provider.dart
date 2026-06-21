import 'package:flutter/material.dart';

enum LoginState { idle, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  LoginState _state = LoginState.idle;
  String? _errorMessage;
  bool _keepSession = true;
  bool _obscurePassword = true;

  String? emailError;
  String? passwordError;

  LoginState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get keepSession => _keepSession;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _state == LoginState.loading;

  void toggleKeepSession() {
    _keepSession = !_keepSession;
    notifyListeners();
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError = null;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      emailError = 'Ingresa un correo válido';
    } else {
      emailError = null;
    }
    notifyListeners();
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError = null;
    } else if (value.length < 8) {
      passwordError = 'Mínimo 8 caracteres';
    } else {
      passwordError = null;
    }
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    if (email.isEmpty) {
      emailError = 'El correo es obligatorio';
      notifyListeners();
      return;
    }
    if (password.isEmpty) {
      passwordError = 'La contraseña es obligatoria';
      notifyListeners();
      return;
    }
    if (emailError != null || passwordError != null) return;

    _state = LoginState.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _state = LoginState.success;
    notifyListeners();
    onSuccess();
  }

  void reset() {
    _state = LoginState.idle;
    _errorMessage = null;
    emailError = null;
    passwordError = null;
    notifyListeners();
  }
}
