// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Servicio de ubicación (core). `keepAlive`: singleton de sesión.

@ProviderFor(locationService)
final locationServiceProvider = LocationServiceProvider._();

/// Servicio de ubicación (core). `keepAlive`: singleton de sesión.

final class LocationServiceProvider extends $FunctionalProvider<LocationService,
    LocationService, LocationService> with $Provider<LocationService> {
  /// Servicio de ubicación (core). `keepAlive`: singleton de sesión.
  LocationServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'locationServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'38ada00c14c0c2521e7d291f9897c53df2e7008a';
