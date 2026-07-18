// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cadena de dependencias de la feature `devices` (registro de token FCM para
/// push): datasource → repositorio → use cases → [DeviceRegistrar].

@ProviderFor(dispositivoRemoteDataSource)
final dispositivoRemoteDataSourceProvider =
    DispositivoRemoteDataSourceProvider._();

/// Cadena de dependencias de la feature `devices` (registro de token FCM para
/// push): datasource → repositorio → use cases → [DeviceRegistrar].

final class DispositivoRemoteDataSourceProvider extends $FunctionalProvider<
    DispositivoRemoteDataSource,
    DispositivoRemoteDataSource,
    DispositivoRemoteDataSource> with $Provider<DispositivoRemoteDataSource> {
  /// Cadena de dependencias de la feature `devices` (registro de token FCM para
  /// push): datasource → repositorio → use cases → [DeviceRegistrar].
  DispositivoRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dispositivoRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dispositivoRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<DispositivoRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DispositivoRemoteDataSource create(Ref ref) {
    return dispositivoRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DispositivoRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DispositivoRemoteDataSource>(value),
    );
  }
}

String _$dispositivoRemoteDataSourceHash() =>
    r'4685b562ca622f9ef0095f9c6469664b5faeb863';

@ProviderFor(dispositivoRepository)
final dispositivoRepositoryProvider = DispositivoRepositoryProvider._();

final class DispositivoRepositoryProvider extends $FunctionalProvider<
    DispositivoRepository,
    DispositivoRepository,
    DispositivoRepository> with $Provider<DispositivoRepository> {
  DispositivoRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dispositivoRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dispositivoRepositoryHash();

  @$internal
  @override
  $ProviderElement<DispositivoRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DispositivoRepository create(Ref ref) {
    return dispositivoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DispositivoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DispositivoRepository>(value),
    );
  }
}

String _$dispositivoRepositoryHash() =>
    r'13ee463ee9d55b134e20753c70b663cf4044fd2d';

@ProviderFor(deviceRegistrar)
final deviceRegistrarProvider = DeviceRegistrarProvider._();

final class DeviceRegistrarProvider extends $FunctionalProvider<DeviceRegistrar,
    DeviceRegistrar, DeviceRegistrar> with $Provider<DeviceRegistrar> {
  DeviceRegistrarProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'deviceRegistrarProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$deviceRegistrarHash();

  @$internal
  @override
  $ProviderElement<DeviceRegistrar> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceRegistrar create(Ref ref) {
    return deviceRegistrar(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceRegistrar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceRegistrar>(value),
    );
  }
}

String _$deviceRegistrarHash() => r'ee2a0c11ae5d946994840c9ae59e2e3eaf192645';
