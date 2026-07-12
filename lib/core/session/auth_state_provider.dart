import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../di/token_storage_provider.dart';

part 'auth_state_provider.g.dart';

/// Estado de sesión: `true` si hay un token guardado (auto-login).
///
/// Escucha a `TokenStorage` (vía [tokenStorageProvider]) y reemite cuando el
/// token cambia (login / logout / expiración). Reemplaza al
/// `ListenableBuilder + getIt<TokenStorage>()` que vivía en la UI.
@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() {
    final storage = ref.watch(tokenStorageProvider);
    void listener() => state = storage.hasToken;
    storage.addListener(listener);
    ref.onDispose(() => storage.removeListener(listener));
    return storage.hasToken;
  }
}
