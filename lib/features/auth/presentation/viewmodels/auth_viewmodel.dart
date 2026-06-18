import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecases.dart';

part 'auth_viewmodel.g.dart';

// ────────────────────────────────────────────────────────────
// Estado
// ────────────────────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final User user;
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

// ────────────────────────────────────────────────────────────
// ViewModel
// ────────────────────────────────────────────────────────────

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthState build() => const AuthInitial();

  LoginUseCase get _login => getIt<LoginUseCase>();
  RegisterUseCase get _register => getIt<RegisterUseCase>();
  LogoutUseCase get _logout => getIt<LogoutUseCase>();

  /// Inicia sesión con email y contraseña.
  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();
    final result = await _login(email: email, password: password);
    state = result.fold(
      (failure) => AuthError(failure.message),
      (user) => AuthAuthenticated(user),
    );
  }

  /// Registra un nuevo usuario.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    final result = await _register(name: name, email: email, password: password);
    state = result.fold(
      (failure) => AuthError(failure.message),
      (user) => AuthAuthenticated(user),
    );
  }

  /// Cierra sesión.
  Future<void> logout() async {
    final result = await _logout();
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthUnauthenticated(),
    );
  }

  /// Limpia el error actual.
  void clearError() {
    if (state is AuthError) state = const AuthInitial();
  }
}
