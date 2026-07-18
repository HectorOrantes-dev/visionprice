// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Estado de sesión: `true` si hay un token guardado (auto-login).
///
/// Escucha a `TokenStorage` (vía [tokenStorageProvider]) y reemite cuando el
/// token cambia (login / logout / expiración). Reemplaza al
/// `ListenableBuilder + getIt<TokenStorage>()` que vivía en la UI.

@ProviderFor(AuthState)
final authStateProvider = AuthStateProvider._();

/// Estado de sesión: `true` si hay un token guardado (auto-login).
///
/// Escucha a `TokenStorage` (vía [tokenStorageProvider]) y reemite cuando el
/// token cambia (login / logout / expiración). Reemplaza al
/// `ListenableBuilder + getIt<TokenStorage>()` que vivía en la UI.
final class AuthStateProvider extends $NotifierProvider<AuthState, bool> {
  /// Estado de sesión: `true` si hay un token guardado (auto-login).
  ///
  /// Escucha a `TokenStorage` (vía [tokenStorageProvider]) y reemite cuando el
  /// token cambia (login / logout / expiración). Reemplaza al
  /// `ListenableBuilder + getIt<TokenStorage>()` que vivía en la UI.
  AuthStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  AuthState create() => AuthState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$authStateHash() => r'76a919651dbd992b24b25b111a1e27e58399244a';

/// Estado de sesión: `true` si hay un token guardado (auto-login).
///
/// Escucha a `TokenStorage` (vía [tokenStorageProvider]) y reemite cuando el
/// token cambia (login / logout / expiración). Reemplaza al
/// `ListenableBuilder + getIt<TokenStorage>()` que vivía en la UI.

abstract class _$AuthState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
