// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier del registro (Riverpod moderno). Reemplaza al `RegisterViewModel`
/// (ChangeNotifier). Carga los roles al construirse y reutiliza el use case de
/// verificación 2FA (mismo mecanismo que el login).

@ProviderFor(Register)
final registerProvider = RegisterProvider._();

/// Notifier del registro (Riverpod moderno). Reemplaza al `RegisterViewModel`
/// (ChangeNotifier). Carga los roles al construirse y reutiliza el use case de
/// verificación 2FA (mismo mecanismo que el login).
final class RegisterProvider
    extends $NotifierProvider<Register, RegisterState> {
  /// Notifier del registro (Riverpod moderno). Reemplaza al `RegisterViewModel`
  /// (ChangeNotifier). Carga los roles al construirse y reutiliza el use case de
  /// verificación 2FA (mismo mecanismo que el login).
  RegisterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'registerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$registerHash();

  @$internal
  @override
  Register create() => Register();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterState>(value),
    );
  }
}

String _$registerHash() => r'6313075c9df38cc1f624a38ed341d25f1af40782';

/// Notifier del registro (Riverpod moderno). Reemplaza al `RegisterViewModel`
/// (ChangeNotifier). Carga los roles al construirse y reutiliza el use case de
/// verificación 2FA (mismo mecanismo que el login).

abstract class _$Register extends $Notifier<RegisterState> {
  RegisterState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RegisterState, RegisterState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<RegisterState, RegisterState>,
        RegisterState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
