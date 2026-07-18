// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_stores_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier de "Ferreterías cercanas" (Riverpod moderno). Obtiene la ubicación,
/// lista los productos cercanos y permite elegir a qué superficie se aplica cada
/// uno para crear la cotización. Reemplaza al `NearbyStoresViewModel`.

@ProviderFor(NearbyStores)
final nearbyStoresProvider = NearbyStoresProvider._();

/// Notifier de "Ferreterías cercanas" (Riverpod moderno). Obtiene la ubicación,
/// lista los productos cercanos y permite elegir a qué superficie se aplica cada
/// uno para crear la cotización. Reemplaza al `NearbyStoresViewModel`.
final class NearbyStoresProvider
    extends $NotifierProvider<NearbyStores, NearbyStoresState> {
  /// Notifier de "Ferreterías cercanas" (Riverpod moderno). Obtiene la ubicación,
  /// lista los productos cercanos y permite elegir a qué superficie se aplica cada
  /// uno para crear la cotización. Reemplaza al `NearbyStoresViewModel`.
  NearbyStoresProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'nearbyStoresProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$nearbyStoresHash();

  @$internal
  @override
  NearbyStores create() => NearbyStores();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NearbyStoresState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NearbyStoresState>(value),
    );
  }
}

String _$nearbyStoresHash() => r'4c1033ebd034eaf000cb6338740e29d225e167a6';

/// Notifier de "Ferreterías cercanas" (Riverpod moderno). Obtiene la ubicación,
/// lista los productos cercanos y permite elegir a qué superficie se aplica cada
/// uno para crear la cotización. Reemplaza al `NearbyStoresViewModel`.

abstract class _$NearbyStores extends $Notifier<NearbyStoresState> {
  NearbyStoresState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NearbyStoresState, NearbyStoresState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<NearbyStoresState, NearbyStoresState>,
        NearbyStoresState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
