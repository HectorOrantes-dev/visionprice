// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cotizacionRemoteDataSourceHash() =>
    r'7a77d389788c8826990dcefbaef18602c7084248';

/// Cadena de dependencias de cotizaciones como providers de Riverpod.
///
/// Copied from [cotizacionRemoteDataSource].
@ProviderFor(cotizacionRemoteDataSource)
final cotizacionRemoteDataSourceProvider =
    Provider<CotizacionRemoteDataSource>.internal(
  cotizacionRemoteDataSource,
  name: r'cotizacionRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cotizacionRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CotizacionRemoteDataSourceRef = ProviderRef<CotizacionRemoteDataSource>;
String _$cotizacionRepositoryHash() =>
    r'5c699aa8997678d3ca9a0333f51071f378dd1eda';

/// See also [cotizacionRepository].
@ProviderFor(cotizacionRepository)
final cotizacionRepositoryProvider = Provider<CotizacionRepository>.internal(
  cotizacionRepository,
  name: r'cotizacionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cotizacionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CotizacionRepositoryRef = ProviderRef<CotizacionRepository>;
String _$obtenerProductosUseCaseHash() =>
    r'54a398e807a403f49751fd784cb68c311208ef18';

/// See also [obtenerProductosUseCase].
@ProviderFor(obtenerProductosUseCase)
final obtenerProductosUseCaseProvider =
    AutoDisposeProvider<ObtenerProductosUseCase>.internal(
  obtenerProductosUseCase,
  name: r'obtenerProductosUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$obtenerProductosUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ObtenerProductosUseCaseRef
    = AutoDisposeProviderRef<ObtenerProductosUseCase>;
String _$crearCotizacionUseCaseHash() =>
    r'672c8180635a38adf8cc559c40e9ac5c3d6f992d';

/// See also [crearCotizacionUseCase].
@ProviderFor(crearCotizacionUseCase)
final crearCotizacionUseCaseProvider =
    AutoDisposeProvider<CrearCotizacionUseCase>.internal(
  crearCotizacionUseCase,
  name: r'crearCotizacionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crearCotizacionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CrearCotizacionUseCaseRef
    = AutoDisposeProviderRef<CrearCotizacionUseCase>;
String _$obtenerPdfUseCaseHash() => r'a751427bd6ae493658417faaa2c5b34b182a9d5b';

/// See also [obtenerPdfUseCase].
@ProviderFor(obtenerPdfUseCase)
final obtenerPdfUseCaseProvider =
    AutoDisposeProvider<ObtenerPdfUseCase>.internal(
  obtenerPdfUseCase,
  name: r'obtenerPdfUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$obtenerPdfUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ObtenerPdfUseCaseRef = AutoDisposeProviderRef<ObtenerPdfUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
