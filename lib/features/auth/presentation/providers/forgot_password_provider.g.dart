// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier del flujo "¿Olvidaste tu contraseña?" (Riverpod moderno). Reemplaza
/// al antiguo `ForgotPasswordViewModel` (ChangeNotifier). Estado inmutable en
/// [ForgotPasswordState]; dependencias resueltas vía `ref`.

@ProviderFor(ForgotPassword)
final forgotPasswordProvider = ForgotPasswordProvider._();

/// Notifier del flujo "¿Olvidaste tu contraseña?" (Riverpod moderno). Reemplaza
/// al antiguo `ForgotPasswordViewModel` (ChangeNotifier). Estado inmutable en
/// [ForgotPasswordState]; dependencias resueltas vía `ref`.
final class ForgotPasswordProvider
    extends $NotifierProvider<ForgotPassword, ForgotPasswordState> {
  /// Notifier del flujo "¿Olvidaste tu contraseña?" (Riverpod moderno). Reemplaza
  /// al antiguo `ForgotPasswordViewModel` (ChangeNotifier). Estado inmutable en
  /// [ForgotPasswordState]; dependencias resueltas vía `ref`.
  ForgotPasswordProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'forgotPasswordProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordHash();

  @$internal
  @override
  ForgotPassword create() => ForgotPassword();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ForgotPasswordState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ForgotPasswordState>(value),
    );
  }
}

String _$forgotPasswordHash() => r'4713ec2312d1283dbe387e6e374c3fa90708c38f';

/// Notifier del flujo "¿Olvidaste tu contraseña?" (Riverpod moderno). Reemplaza
/// al antiguo `ForgotPasswordViewModel` (ChangeNotifier). Estado inmutable en
/// [ForgotPasswordState]; dependencias resueltas vía `ref`.

abstract class _$ForgotPassword extends $Notifier<ForgotPasswordState> {
  ForgotPasswordState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ForgotPasswordState, ForgotPasswordState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ForgotPasswordState, ForgotPasswordState>,
        ForgotPasswordState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
