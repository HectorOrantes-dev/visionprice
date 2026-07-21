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

@ProviderFor(crearSuscripcionConektaUseCase)
final crearSuscripcionConektaUseCaseProvider =
    CrearSuscripcionConektaUseCaseProvider._();

final class CrearSuscripcionConektaUseCaseProvider extends $FunctionalProvider<
        CrearSuscripcionConektaUseCase,
        CrearSuscripcionConektaUseCase,
        CrearSuscripcionConektaUseCase>
    with $Provider<CrearSuscripcionConektaUseCase> {
  CrearSuscripcionConektaUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'crearSuscripcionConektaUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$crearSuscripcionConektaUseCaseHash();

  @$internal
  @override
  $ProviderElement<CrearSuscripcionConektaUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CrearSuscripcionConektaUseCase create(Ref ref) {
    return crearSuscripcionConektaUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrearSuscripcionConektaUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<CrearSuscripcionConektaUseCase>(value),
    );
  }
}

String _$crearSuscripcionConektaUseCaseHash() =>
    r'81499756e3cac10489a2aff1ff771febf04cb824';

@ProviderFor(cancelarSuscripcionConektaUseCase)
final cancelarSuscripcionConektaUseCaseProvider =
    CancelarSuscripcionConektaUseCaseProvider._();

final class CancelarSuscripcionConektaUseCaseProvider
    extends $FunctionalProvider<CancelarSuscripcionConektaUseCase,
        CancelarSuscripcionConektaUseCase, CancelarSuscripcionConektaUseCase>
    with $Provider<CancelarSuscripcionConektaUseCase> {
  CancelarSuscripcionConektaUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cancelarSuscripcionConektaUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() =>
      _$cancelarSuscripcionConektaUseCaseHash();

  @$internal
  @override
  $ProviderElement<CancelarSuscripcionConektaUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CancelarSuscripcionConektaUseCase create(Ref ref) {
    return cancelarSuscripcionConektaUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CancelarSuscripcionConektaUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<CancelarSuscripcionConektaUseCase>(value),
    );
  }
}

String _$cancelarSuscripcionConektaUseCaseHash() =>
    r'87da686161eb85656cf5615dfd5d42fcce9edb87';

@ProviderFor(eliminarMetodoPagoConektaUseCase)
final eliminarMetodoPagoConektaUseCaseProvider =
    EliminarMetodoPagoConektaUseCaseProvider._();

final class EliminarMetodoPagoConektaUseCaseProvider
    extends $FunctionalProvider<EliminarMetodoPagoConektaUseCase,
        EliminarMetodoPagoConektaUseCase, EliminarMetodoPagoConektaUseCase>
    with $Provider<EliminarMetodoPagoConektaUseCase> {
  EliminarMetodoPagoConektaUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'eliminarMetodoPagoConektaUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eliminarMetodoPagoConektaUseCaseHash();

  @$internal
  @override
  $ProviderElement<EliminarMetodoPagoConektaUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EliminarMetodoPagoConektaUseCase create(Ref ref) {
    return eliminarMetodoPagoConektaUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EliminarMetodoPagoConektaUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<EliminarMetodoPagoConektaUseCase>(value),
    );
  }
}

String _$eliminarMetodoPagoConektaUseCaseHash() =>
    r'4705f7ae48f29031ab92fb2eabfaf6a584de9851';

@ProviderFor(crearSuscripcionPaypalUseCase)
final crearSuscripcionPaypalUseCaseProvider =
    CrearSuscripcionPaypalUseCaseProvider._();

final class CrearSuscripcionPaypalUseCaseProvider extends $FunctionalProvider<
        CrearSuscripcionPaypalUseCase,
        CrearSuscripcionPaypalUseCase,
        CrearSuscripcionPaypalUseCase>
    with $Provider<CrearSuscripcionPaypalUseCase> {
  CrearSuscripcionPaypalUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'crearSuscripcionPaypalUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$crearSuscripcionPaypalUseCaseHash();

  @$internal
  @override
  $ProviderElement<CrearSuscripcionPaypalUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CrearSuscripcionPaypalUseCase create(Ref ref) {
    return crearSuscripcionPaypalUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrearSuscripcionPaypalUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<CrearSuscripcionPaypalUseCase>(value),
    );
  }
}

String _$crearSuscripcionPaypalUseCaseHash() =>
    r'e1db10a5c877484f01e76c4de194e53101d4acbc';

@ProviderFor(cancelarSuscripcionPaypalUseCase)
final cancelarSuscripcionPaypalUseCaseProvider =
    CancelarSuscripcionPaypalUseCaseProvider._();

final class CancelarSuscripcionPaypalUseCaseProvider
    extends $FunctionalProvider<CancelarSuscripcionPaypalUseCase,
        CancelarSuscripcionPaypalUseCase, CancelarSuscripcionPaypalUseCase>
    with $Provider<CancelarSuscripcionPaypalUseCase> {
  CancelarSuscripcionPaypalUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cancelarSuscripcionPaypalUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cancelarSuscripcionPaypalUseCaseHash();

  @$internal
  @override
  $ProviderElement<CancelarSuscripcionPaypalUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CancelarSuscripcionPaypalUseCase create(Ref ref) {
    return cancelarSuscripcionPaypalUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CancelarSuscripcionPaypalUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<CancelarSuscripcionPaypalUseCase>(value),
    );
  }
}

String _$cancelarSuscripcionPaypalUseCaseHash() =>
    r'814e3ddc09f9d8a72fdbce75b44ee19bfc1d1b00';
