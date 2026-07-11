// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountRemoteDataSourceHash() =>
    r'1732ec1ee63c28154cdfb3cfdc12f731736dacba';

/// Cadena de dependencias de cuenta/suscripciones como providers de Riverpod.
///
/// Copied from [accountRemoteDataSource].
@ProviderFor(accountRemoteDataSource)
final accountRemoteDataSourceProvider =
    Provider<AccountRemoteDataSource>.internal(
  accountRemoteDataSource,
  name: r'accountRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountRemoteDataSourceRef = ProviderRef<AccountRemoteDataSource>;
String _$accountRepositoryHash() => r'45c961235d113f02caa907a35711a18435663858';

/// See also [accountRepository].
@ProviderFor(accountRepository)
final accountRepositoryProvider = Provider<AccountRepository>.internal(
  accountRepository,
  name: r'accountRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountRepositoryRef = ProviderRef<AccountRepository>;
String _$obtenerSuscripcionesUseCaseHash() =>
    r'3a8f30260e97fa1c1626bb6b7f916b031ea24aee';

/// See also [obtenerSuscripcionesUseCase].
@ProviderFor(obtenerSuscripcionesUseCase)
final obtenerSuscripcionesUseCaseProvider =
    AutoDisposeProvider<ObtenerSuscripcionesUseCase>.internal(
  obtenerSuscripcionesUseCase,
  name: r'obtenerSuscripcionesUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$obtenerSuscripcionesUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ObtenerSuscripcionesUseCaseRef
    = AutoDisposeProviderRef<ObtenerSuscripcionesUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
