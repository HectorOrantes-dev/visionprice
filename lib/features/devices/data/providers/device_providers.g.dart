// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dispositivoRemoteDataSourceHash() =>
    r'1158dddcdbabe4b0b6c9e9f7ca2e6d275086ef9b';

/// Cadena de dependencias de la feature `devices` (registro de token FCM para
/// push): datasource → repositorio → use cases → [DeviceRegistrar].
///
/// Copied from [dispositivoRemoteDataSource].
@ProviderFor(dispositivoRemoteDataSource)
final dispositivoRemoteDataSourceProvider =
    Provider<DispositivoRemoteDataSource>.internal(
  dispositivoRemoteDataSource,
  name: r'dispositivoRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dispositivoRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DispositivoRemoteDataSourceRef
    = ProviderRef<DispositivoRemoteDataSource>;
String _$dispositivoRepositoryHash() =>
    r'e9754d2d6adb128a2cc70973ce276f6fdf9a4acc';

/// See also [dispositivoRepository].
@ProviderFor(dispositivoRepository)
final dispositivoRepositoryProvider = Provider<DispositivoRepository>.internal(
  dispositivoRepository,
  name: r'dispositivoRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dispositivoRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DispositivoRepositoryRef = ProviderRef<DispositivoRepository>;
String _$deviceRegistrarHash() => r'2e5f505545463df209a397d737cad0456b7031e4';

/// See also [deviceRegistrar].
@ProviderFor(deviceRegistrar)
final deviceRegistrarProvider = Provider<DeviceRegistrar>.internal(
  deviceRegistrar,
  name: r'deviceRegistrarProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deviceRegistrarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeviceRegistrarRef = ProviderRef<DeviceRegistrar>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
