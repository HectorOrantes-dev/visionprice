import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/api_client_provider.dart';
import '../datasources/dispositivo_remote_datasource.dart';
import '../datasources/dispositivo_remote_datasource_impl.dart';
import '../repositories/dispositivo_repository_impl.dart';
import '../services/device_registrar.dart';
import '../../domain/repositories/dispositivo_repository.dart';
import '../../domain/usecases/dispositivo_usecases.dart';

part 'device_providers.g.dart';

/// Cadena de dependencias de la feature `devices` (registro de token FCM para
/// push): datasource → repositorio → use cases → [DeviceRegistrar].

@Riverpod(keepAlive: true)
DispositivoRemoteDataSource dispositivoRemoteDataSource(
        Ref ref) =>
    DispositivoRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
DispositivoRepository dispositivoRepository(Ref ref) =>
    DispositivoRepositoryImpl(ref.watch(dispositivoRemoteDataSourceProvider));

@Riverpod(keepAlive: true)
DeviceRegistrar deviceRegistrar(Ref ref) => DeviceRegistrar(
      RegistrarDispositivoUseCase(ref.watch(dispositivoRepositoryProvider)),
      BorrarDispositivoUseCase(ref.watch(dispositivoRepositoryProvider)),
    );
