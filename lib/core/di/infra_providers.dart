import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/api_client.dart';
import '../network/connectivity_service.dart';
import '../services/location_service.dart';
import '../storage/local_database.dart';
import '../storage/token_storage.dart';

part 'infra_providers.g.dart';

/// Providers de infraestructura **compartida** (core), construidos nativamente
/// en Riverpod. `keepAlive`: viven toda la sesión, como singletons.
///
/// Aquí solo va infra transversal usada por varias features. Las cadenas de
/// cada feature viven en su propio `*_providers.dart` (p. ej.
/// `features/devices/.../device_providers.dart`).

@Riverpod(keepAlive: true)
http.Client httpClient(HttpClientRef ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(TokenStorageRef ref) => TokenStorage();

@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) => ApiClient(
      ref.watch(httpClientProvider),
      ref.watch(tokenStorageProvider),
    );

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(ConnectivityServiceRef ref) =>
    ConnectivityService(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
LocalDatabase localDatabase(LocalDatabaseRef ref) => LocalDatabase();

@Riverpod(keepAlive: true)
LocationService locationService(LocationServiceRef ref) => LocationService();
