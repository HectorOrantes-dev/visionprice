// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_stores_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nearbyStoresHash() => r'9fa742d4c96a25f045b85da2aef056a8fe93a5db';

/// Notifier de "Ferreterías cercanas" (Riverpod moderno). Obtiene la ubicación,
/// lista los productos cercanos y permite elegir a qué superficie se aplica cada
/// uno para crear la cotización. Reemplaza al `NearbyStoresViewModel`.
///
/// Copied from [NearbyStores].
@ProviderFor(NearbyStores)
final nearbyStoresProvider =
    AutoDisposeNotifierProvider<NearbyStores, NearbyStoresState>.internal(
  NearbyStores.new,
  name: r'nearbyStoresProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$nearbyStoresHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NearbyStores = AutoDisposeNotifier<NearbyStoresState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
