// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRemoteDataSourceHash() =>
    r'b842882c7968970499085c9d6156ac14bfaf43cb';

/// Cadena de dependencias de auth expresada como providers de Riverpod
/// (composición declarativa). Reemplaza el registro get_it para esta feature.
/// keepAlive: el repositorio cachea el perfil en memoria durante la sesión.
///
/// Copied from [authRemoteDataSource].
@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>.internal(
  authRemoteDataSource,
  name: r'authRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRemoteDataSourceRef = ProviderRef<AuthRemoteDataSource>;
String _$authRepositoryHash() => r'7ee7741317f975a8c03fce1569123ace95a33d94';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$loginUseCaseHash() => r'454c98b7ce9250e37d1786d1ac755601f6a0f81e';

/// See also [loginUseCase].
@ProviderFor(loginUseCase)
final loginUseCaseProvider = AutoDisposeProvider<LoginUseCase>.internal(
  loginUseCase,
  name: r'loginUseCaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loginUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoginUseCaseRef = AutoDisposeProviderRef<LoginUseCase>;
String _$verifyTwoFactorUseCaseHash() =>
    r'741e5d1fec0e34fd9be52edb42150fdc518f51b1';

/// See also [verifyTwoFactorUseCase].
@ProviderFor(verifyTwoFactorUseCase)
final verifyTwoFactorUseCaseProvider =
    AutoDisposeProvider<VerifyTwoFactorUseCase>.internal(
  verifyTwoFactorUseCase,
  name: r'verifyTwoFactorUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$verifyTwoFactorUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VerifyTwoFactorUseCaseRef
    = AutoDisposeProviderRef<VerifyTwoFactorUseCase>;
String _$googleLoginUseCaseHash() =>
    r'9a7ff4030ea88224a99a7be00fa35ca41642ac91';

/// See also [googleLoginUseCase].
@ProviderFor(googleLoginUseCase)
final googleLoginUseCaseProvider =
    AutoDisposeProvider<GoogleLoginUseCase>.internal(
  googleLoginUseCase,
  name: r'googleLoginUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$googleLoginUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoogleLoginUseCaseRef = AutoDisposeProviderRef<GoogleLoginUseCase>;
String _$googleRegisterUseCaseHash() =>
    r'1ab22d8b4bce1c03a4a66ddf0388c66b7e40a980';

/// See also [googleRegisterUseCase].
@ProviderFor(googleRegisterUseCase)
final googleRegisterUseCaseProvider =
    AutoDisposeProvider<GoogleRegisterUseCase>.internal(
  googleRegisterUseCase,
  name: r'googleRegisterUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$googleRegisterUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoogleRegisterUseCaseRef
    = AutoDisposeProviderRef<GoogleRegisterUseCase>;
String _$getRolesUseCaseHash() => r'b1a773b0211f21e243c2d5d98d97803340461ec6';

/// See also [getRolesUseCase].
@ProviderFor(getRolesUseCase)
final getRolesUseCaseProvider = AutoDisposeProvider<GetRolesUseCase>.internal(
  getRolesUseCase,
  name: r'getRolesUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getRolesUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetRolesUseCaseRef = AutoDisposeProviderRef<GetRolesUseCase>;
String _$registerUseCaseHash() => r'14992d114f9dbe75d0320a42fecd77955238d6d9';

/// See also [registerUseCase].
@ProviderFor(registerUseCase)
final registerUseCaseProvider = AutoDisposeProvider<RegisterUseCase>.internal(
  registerUseCase,
  name: r'registerUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$registerUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RegisterUseCaseRef = AutoDisposeProviderRef<RegisterUseCase>;
String _$forgotPasswordUseCaseHash() =>
    r'2e7464599bc68ff192e187d09948587bab24c04d';

/// See also [forgotPasswordUseCase].
@ProviderFor(forgotPasswordUseCase)
final forgotPasswordUseCaseProvider =
    AutoDisposeProvider<ForgotPasswordUseCase>.internal(
  forgotPasswordUseCase,
  name: r'forgotPasswordUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forgotPasswordUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ForgotPasswordUseCaseRef
    = AutoDisposeProviderRef<ForgotPasswordUseCase>;
String _$verifyResetCodeUseCaseHash() =>
    r'bcb94870d6813f8ffc073ef569342334e88f728b';

/// See also [verifyResetCodeUseCase].
@ProviderFor(verifyResetCodeUseCase)
final verifyResetCodeUseCaseProvider =
    AutoDisposeProvider<VerifyResetCodeUseCase>.internal(
  verifyResetCodeUseCase,
  name: r'verifyResetCodeUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$verifyResetCodeUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VerifyResetCodeUseCaseRef
    = AutoDisposeProviderRef<VerifyResetCodeUseCase>;
String _$resetPasswordUseCaseHash() =>
    r'b1c402a616ea71a8bf168e5d6a2ff7697417abf3';

/// See also [resetPasswordUseCase].
@ProviderFor(resetPasswordUseCase)
final resetPasswordUseCaseProvider =
    AutoDisposeProvider<ResetPasswordUseCase>.internal(
  resetPasswordUseCase,
  name: r'resetPasswordUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resetPasswordUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResetPasswordUseCaseRef = AutoDisposeProviderRef<ResetPasswordUseCase>;
String _$getPerfilUseCaseHash() => r'029e21eb5b68137df26769853cc03f52cb0b44ee';

/// See also [getPerfilUseCase].
@ProviderFor(getPerfilUseCase)
final getPerfilUseCaseProvider = AutoDisposeProvider<GetPerfilUseCase>.internal(
  getPerfilUseCase,
  name: r'getPerfilUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getPerfilUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetPerfilUseCaseRef = AutoDisposeProviderRef<GetPerfilUseCase>;
String _$logoutUseCaseHash() => r'd17b425250472908f13754406736aea68aa11b38';

/// See also [logoutUseCase].
@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = AutoDisposeProvider<LogoutUseCase>.internal(
  logoutUseCase,
  name: r'logoutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$logoutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LogoutUseCaseRef = AutoDisposeProviderRef<LogoutUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
