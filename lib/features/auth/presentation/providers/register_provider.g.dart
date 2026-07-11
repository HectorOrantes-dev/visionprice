// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$registerHash() => r'59429ac5ec093d798923a67579da5b5f27342ded';

/// Notifier del registro (Riverpod moderno). Reemplaza al `RegisterViewModel`
/// (ChangeNotifier). Carga los roles al construirse y reutiliza el use case de
/// verificación 2FA (mismo mecanismo que el login).
///
/// Copied from [Register].
@ProviderFor(Register)
final registerProvider =
    AutoDisposeNotifierProvider<Register, RegisterState>.internal(
  Register.new,
  name: r'registerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$registerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Register = AutoDisposeNotifier<RegisterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
