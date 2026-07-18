// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Servicio de conectividad real (ping al back-end). `keepAlive`: singleton.

@ProviderFor(connectivityService)
final connectivityServiceProvider = ConnectivityServiceProvider._();

/// Servicio de conectividad real (ping al back-end). `keepAlive`: singleton.

final class ConnectivityServiceProvider extends $FunctionalProvider<
    ConnectivityService,
    ConnectivityService,
    ConnectivityService> with $Provider<ConnectivityService> {
  /// Servicio de conectividad real (ping al back-end). `keepAlive`: singleton.
  ConnectivityServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'connectivityServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$connectivityServiceHash();

  @$internal
  @override
  $ProviderElement<ConnectivityService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConnectivityService create(Ref ref) {
    return connectivityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectivityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectivityService>(value),
    );
  }
}

String _$connectivityServiceHash() =>
    r'b7991ee0e29c31047b81c2ed5cbbed7165a37da6';
