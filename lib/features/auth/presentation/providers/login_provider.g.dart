// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier del login (enfoque moderno de Riverpod). Reemplaza al antiguo
/// `LoginViewModel` (ChangeNotifier). El estado vive en [LoginState] inmutable;
/// las dependencias (use cases, device registrar) se resuelven vía `ref`.
///
/// Usa [ValidationMixin] para la validación de formularios (sin duplicar).

@ProviderFor(Login)
final loginProvider = LoginProvider._();

/// Notifier del login (enfoque moderno de Riverpod). Reemplaza al antiguo
/// `LoginViewModel` (ChangeNotifier). El estado vive en [LoginState] inmutable;
/// las dependencias (use cases, device registrar) se resuelven vía `ref`.
///
/// Usa [ValidationMixin] para la validación de formularios (sin duplicar).
final class LoginProvider extends $NotifierProvider<Login, LoginState> {
  /// Notifier del login (enfoque moderno de Riverpod). Reemplaza al antiguo
  /// `LoginViewModel` (ChangeNotifier). El estado vive en [LoginState] inmutable;
  /// las dependencias (use cases, device registrar) se resuelven vía `ref`.
  ///
  /// Usa [ValidationMixin] para la validación de formularios (sin duplicar).
  LoginProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'loginProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$loginHash();

  @$internal
  @override
  Login create() => Login();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginState>(value),
    );
  }
}

String _$loginHash() => r'b7988ee10a6b8e8dfb597e5befd774aa5d62ec97';

/// Notifier del login (enfoque moderno de Riverpod). Reemplaza al antiguo
/// `LoginViewModel` (ChangeNotifier). El estado vive en [LoginState] inmutable;
/// las dependencias (use cases, device registrar) se resuelven vía `ref`.
///
/// Usa [ValidationMixin] para la validación de formularios (sin duplicar).

abstract class _$Login extends $Notifier<LoginState> {
  LoginState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LoginState, LoginState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<LoginState, LoginState>, LoginState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
