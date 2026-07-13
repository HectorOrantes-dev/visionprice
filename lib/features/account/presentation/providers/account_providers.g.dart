// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cadena de dependencias de cuenta/suscripciones como providers de Riverpod.

@ProviderFor(accountRemoteDataSource)
final accountRemoteDataSourceProvider = AccountRemoteDataSourceProvider._();

/// Cadena de dependencias de cuenta/suscripciones como providers de Riverpod.

final class AccountRemoteDataSourceProvider extends $FunctionalProvider<
    AccountRemoteDataSource,
    AccountRemoteDataSource,
    AccountRemoteDataSource> with $Provider<AccountRemoteDataSource> {
  /// Cadena de dependencias de cuenta/suscripciones como providers de Riverpod.
  AccountRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'accountRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$accountRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AccountRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountRemoteDataSource create(Ref ref) {
    return accountRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountRemoteDataSource>(value),
    );
  }
}

String _$accountRemoteDataSourceHash() =>
    r'34affd42eec37ceee988afc066c71aee5b037338';

@ProviderFor(accountRepository)
final accountRepositoryProvider = AccountRepositoryProvider._();

final class AccountRepositoryProvider extends $FunctionalProvider<
    AccountRepository,
    AccountRepository,
    AccountRepository> with $Provider<AccountRepository> {
  AccountRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'accountRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$accountRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountRepository create(Ref ref) {
    return accountRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountRepository>(value),
    );
  }
}

String _$accountRepositoryHash() => r'8d84815f49173b78281da2be3b5e50c5899d1eff';

@ProviderFor(obtenerSuscripcionesUseCase)
final obtenerSuscripcionesUseCaseProvider =
    ObtenerSuscripcionesUseCaseProvider._();

final class ObtenerSuscripcionesUseCaseProvider extends $FunctionalProvider<
    ObtenerSuscripcionesUseCase,
    ObtenerSuscripcionesUseCase,
    ObtenerSuscripcionesUseCase> with $Provider<ObtenerSuscripcionesUseCase> {
  ObtenerSuscripcionesUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'obtenerSuscripcionesUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$obtenerSuscripcionesUseCaseHash();

  @$internal
  @override
  $ProviderElement<ObtenerSuscripcionesUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObtenerSuscripcionesUseCase create(Ref ref) {
    return obtenerSuscripcionesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObtenerSuscripcionesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObtenerSuscripcionesUseCase>(value),
    );
  }
}

String _$obtenerSuscripcionesUseCaseHash() =>
    r'ef2b47b92d29420fdd1f92a95ed55a2f66584a0b';
