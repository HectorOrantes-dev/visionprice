// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cadena de dependencias de auth expresada como providers de Riverpod
/// (composición declarativa). Reemplaza el registro get_it para esta feature.
/// keepAlive: el repositorio cachea el perfil en memoria durante la sesión.

@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

/// Cadena de dependencias de auth expresada como providers de Riverpod
/// (composición declarativa). Reemplaza el registro get_it para esta feature.
/// keepAlive: el repositorio cachea el perfil en memoria durante la sesión.

final class AuthRemoteDataSourceProvider extends $FunctionalProvider<
    AuthRemoteDataSource,
    AuthRemoteDataSource,
    AuthRemoteDataSource> with $Provider<AuthRemoteDataSource> {
  /// Cadena de dependencias de auth expresada como providers de Riverpod
  /// (composición declarativa). Reemplaza el registro get_it para esta feature.
  /// keepAlive: el repositorio cachea el perfil en memoria durante la sesión.
  AuthRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRemoteDataSource create(Ref ref) {
    return authRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteDataSource>(value),
    );
  }
}

String _$authRemoteDataSourceHash() =>
    r'842ee59bb5be73a4a5a3b907005608bb12a0cab3';

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'e3b07b9362aad249631023e54ef14e2c2d52d474';

@ProviderFor(loginUseCase)
final loginUseCaseProvider = LoginUseCaseProvider._();

final class LoginUseCaseProvider
    extends $FunctionalProvider<LoginUseCase, LoginUseCase, LoginUseCase>
    with $Provider<LoginUseCase> {
  LoginUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'loginUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$loginUseCaseHash();

  @$internal
  @override
  $ProviderElement<LoginUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoginUseCase create(Ref ref) {
    return loginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginUseCase>(value),
    );
  }
}

String _$loginUseCaseHash() => r'5a95b111ff086652f0c947b88bcfe26ea7ce95be';

@ProviderFor(verifyTwoFactorUseCase)
final verifyTwoFactorUseCaseProvider = VerifyTwoFactorUseCaseProvider._();

final class VerifyTwoFactorUseCaseProvider extends $FunctionalProvider<
    VerifyTwoFactorUseCase,
    VerifyTwoFactorUseCase,
    VerifyTwoFactorUseCase> with $Provider<VerifyTwoFactorUseCase> {
  VerifyTwoFactorUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'verifyTwoFactorUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$verifyTwoFactorUseCaseHash();

  @$internal
  @override
  $ProviderElement<VerifyTwoFactorUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VerifyTwoFactorUseCase create(Ref ref) {
    return verifyTwoFactorUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerifyTwoFactorUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerifyTwoFactorUseCase>(value),
    );
  }
}

String _$verifyTwoFactorUseCaseHash() =>
    r'cdf9598df82a1c6c61e608111e6eae298d230e9a';

@ProviderFor(googleLoginUseCase)
final googleLoginUseCaseProvider = GoogleLoginUseCaseProvider._();

final class GoogleLoginUseCaseProvider extends $FunctionalProvider<
    GoogleLoginUseCase,
    GoogleLoginUseCase,
    GoogleLoginUseCase> with $Provider<GoogleLoginUseCase> {
  GoogleLoginUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'googleLoginUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$googleLoginUseCaseHash();

  @$internal
  @override
  $ProviderElement<GoogleLoginUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoogleLoginUseCase create(Ref ref) {
    return googleLoginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleLoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleLoginUseCase>(value),
    );
  }
}

String _$googleLoginUseCaseHash() =>
    r'b4324912d5a53f4eb99c577d3a30ba91cb344624';

@ProviderFor(googleRegisterUseCase)
final googleRegisterUseCaseProvider = GoogleRegisterUseCaseProvider._();

final class GoogleRegisterUseCaseProvider extends $FunctionalProvider<
    GoogleRegisterUseCase,
    GoogleRegisterUseCase,
    GoogleRegisterUseCase> with $Provider<GoogleRegisterUseCase> {
  GoogleRegisterUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'googleRegisterUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$googleRegisterUseCaseHash();

  @$internal
  @override
  $ProviderElement<GoogleRegisterUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoogleRegisterUseCase create(Ref ref) {
    return googleRegisterUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleRegisterUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleRegisterUseCase>(value),
    );
  }
}

String _$googleRegisterUseCaseHash() =>
    r'fb9a68a557ef133bfd6af1ea0ccc732220ab9395';

@ProviderFor(getRolesUseCase)
final getRolesUseCaseProvider = GetRolesUseCaseProvider._();

final class GetRolesUseCaseProvider extends $FunctionalProvider<GetRolesUseCase,
    GetRolesUseCase, GetRolesUseCase> with $Provider<GetRolesUseCase> {
  GetRolesUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getRolesUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getRolesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetRolesUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetRolesUseCase create(Ref ref) {
    return getRolesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRolesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRolesUseCase>(value),
    );
  }
}

String _$getRolesUseCaseHash() => r'472ad83563288ffe3f48dc6145ea6c45e1bc07ca';

@ProviderFor(registerUseCase)
final registerUseCaseProvider = RegisterUseCaseProvider._();

final class RegisterUseCaseProvider extends $FunctionalProvider<RegisterUseCase,
    RegisterUseCase, RegisterUseCase> with $Provider<RegisterUseCase> {
  RegisterUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'registerUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$registerUseCaseHash();

  @$internal
  @override
  $ProviderElement<RegisterUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RegisterUseCase create(Ref ref) {
    return registerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterUseCase>(value),
    );
  }
}

String _$registerUseCaseHash() => r'18669430c22e1c7844c19dd3dcbe2285a2250a73';

@ProviderFor(forgotPasswordUseCase)
final forgotPasswordUseCaseProvider = ForgotPasswordUseCaseProvider._();

final class ForgotPasswordUseCaseProvider extends $FunctionalProvider<
    ForgotPasswordUseCase,
    ForgotPasswordUseCase,
    ForgotPasswordUseCase> with $Provider<ForgotPasswordUseCase> {
  ForgotPasswordUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'forgotPasswordUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordUseCaseHash();

  @$internal
  @override
  $ProviderElement<ForgotPasswordUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ForgotPasswordUseCase create(Ref ref) {
    return forgotPasswordUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ForgotPasswordUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ForgotPasswordUseCase>(value),
    );
  }
}

String _$forgotPasswordUseCaseHash() =>
    r'fbdfcfd332abb715b8d3fc0b285a896d26dafb3c';

@ProviderFor(verifyResetCodeUseCase)
final verifyResetCodeUseCaseProvider = VerifyResetCodeUseCaseProvider._();

final class VerifyResetCodeUseCaseProvider extends $FunctionalProvider<
    VerifyResetCodeUseCase,
    VerifyResetCodeUseCase,
    VerifyResetCodeUseCase> with $Provider<VerifyResetCodeUseCase> {
  VerifyResetCodeUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'verifyResetCodeUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$verifyResetCodeUseCaseHash();

  @$internal
  @override
  $ProviderElement<VerifyResetCodeUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VerifyResetCodeUseCase create(Ref ref) {
    return verifyResetCodeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerifyResetCodeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerifyResetCodeUseCase>(value),
    );
  }
}

String _$verifyResetCodeUseCaseHash() =>
    r'8c34b3b7c8619b00a883927055cffbe001e7dd96';

@ProviderFor(resetPasswordUseCase)
final resetPasswordUseCaseProvider = ResetPasswordUseCaseProvider._();

final class ResetPasswordUseCaseProvider extends $FunctionalProvider<
    ResetPasswordUseCase,
    ResetPasswordUseCase,
    ResetPasswordUseCase> with $Provider<ResetPasswordUseCase> {
  ResetPasswordUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'resetPasswordUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordUseCaseHash();

  @$internal
  @override
  $ProviderElement<ResetPasswordUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ResetPasswordUseCase create(Ref ref) {
    return resetPasswordUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResetPasswordUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResetPasswordUseCase>(value),
    );
  }
}

String _$resetPasswordUseCaseHash() =>
    r'954e56b2b94719a458ccec2b3c9101151c1cde49';

@ProviderFor(getPerfilUseCase)
final getPerfilUseCaseProvider = GetPerfilUseCaseProvider._();

final class GetPerfilUseCaseProvider extends $FunctionalProvider<
    GetPerfilUseCase,
    GetPerfilUseCase,
    GetPerfilUseCase> with $Provider<GetPerfilUseCase> {
  GetPerfilUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getPerfilUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getPerfilUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPerfilUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetPerfilUseCase create(Ref ref) {
    return getPerfilUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPerfilUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPerfilUseCase>(value),
    );
  }
}

String _$getPerfilUseCaseHash() => r'9f6156642c3e2827bf9daf950c0ac813d04594ab';

@ProviderFor(actualizarPerfilUseCase)
final actualizarPerfilUseCaseProvider = ActualizarPerfilUseCaseProvider._();

final class ActualizarPerfilUseCaseProvider extends $FunctionalProvider<
    ActualizarPerfilUseCase,
    ActualizarPerfilUseCase,
    ActualizarPerfilUseCase> with $Provider<ActualizarPerfilUseCase> {
  ActualizarPerfilUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'actualizarPerfilUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$actualizarPerfilUseCaseHash();

  @$internal
  @override
  $ProviderElement<ActualizarPerfilUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActualizarPerfilUseCase create(Ref ref) {
    return actualizarPerfilUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActualizarPerfilUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActualizarPerfilUseCase>(value),
    );
  }
}

String _$actualizarPerfilUseCaseHash() =>
    r'b7e561f1045a9e9692f5f0cc23cefa4b5cd7bda0';

@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = LogoutUseCaseProvider._();

final class LogoutUseCaseProvider
    extends $FunctionalProvider<LogoutUseCase, LogoutUseCase, LogoutUseCase>
    with $Provider<LogoutUseCase> {
  LogoutUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'logoutUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$logoutUseCaseHash();

  @$internal
  @override
  $ProviderElement<LogoutUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoutUseCase create(Ref ref) {
    return logoutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoutUseCase>(value),
    );
  }
}

String _$logoutUseCaseHash() => r'c3c6c589cbff5a2f6618cc56b1f9faae632da27a';
