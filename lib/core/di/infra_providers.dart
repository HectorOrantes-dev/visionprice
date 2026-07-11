import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/devices/data/datasources/dispositivo_remote_datasource.dart';
import '../../features/devices/data/datasources/dispositivo_remote_datasource_impl.dart';
import '../../features/devices/data/repositories/dispositivo_repository_impl.dart';
import '../../features/devices/data/services/device_registrar.dart';
import '../../features/devices/domain/repositories/dispositivo_repository.dart';
import '../../features/devices/domain/usecases/dispositivo_usecases.dart';
import '../network/api_client.dart';
import '../network/connectivity_service.dart';
import '../services/location_service.dart';
import '../storage/local_database.dart';
import '../storage/token_storage.dart';

part 'infra_providers.g.dart';

/// Providers de infraestructura compartida, construidos nativamente en Riverpod
/// (composición declarativa). Reemplazan por completo el registro de get_it.
/// `keepAlive`: viven toda la sesión, como singletons.

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

// --- Cadena de dispositivos (push FCM) para DeviceRegistrar ---

@Riverpod(keepAlive: true)
DispositivoRemoteDataSource dispositivoRemoteDataSource(
        DispositivoRemoteDataSourceRef ref) =>
    DispositivoRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
DispositivoRepository dispositivoRepository(DispositivoRepositoryRef ref) =>
    DispositivoRepositoryImpl(ref.watch(dispositivoRemoteDataSourceProvider));

@Riverpod(keepAlive: true)
DeviceRegistrar deviceRegistrar(DeviceRegistrarRef ref) => DeviceRegistrar(
      RegistrarDispositivoUseCase(ref.watch(dispositivoRepositoryProvider)),
      BorrarDispositivoUseCase(ref.watch(dispositivoRepositoryProvider)),
    );
