// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'76a919651dbd992b24b25b111a1e27e58399244a';

/// Estado de sesión: `true` si hay un token guardado (auto-login).
///
/// Escucha a `TokenStorage` (vía [tokenStorageProvider]) y reemite cuando el
/// token cambia (login / logout / expiración). Reemplaza al
/// `ListenableBuilder + getIt<TokenStorage>()` que vivía en la UI.
///
/// Copied from [AuthState].
@ProviderFor(AuthState)
final authStateProvider = AutoDisposeNotifierProvider<AuthState, bool>.internal(
  AuthState.new,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
