// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginHash() => r'b7988ee10a6b8e8dfb597e5befd774aa5d62ec97';

/// Notifier del login (enfoque moderno de Riverpod). Reemplaza al antiguo
/// `LoginViewModel` (ChangeNotifier). El estado vive en [LoginState] inmutable;
/// las dependencias (use cases, device registrar) se resuelven vía `ref`.
///
/// Usa [ValidationMixin] para la validación de formularios (sin duplicar).
///
/// Copied from [Login].
@ProviderFor(Login)
final loginProvider = AutoDisposeNotifierProvider<Login, LoginState>.internal(
  Login.new,
  name: r'loginProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loginHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Login = AutoDisposeNotifier<LoginState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
