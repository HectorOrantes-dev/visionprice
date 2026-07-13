import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/api_client_provider.dart';
import '../../../../core/di/local_database_provider.dart';
import '../../../../core/di/token_storage_provider.dart';
import '../../../sync/data/datasources/sync_local_datasource.dart';
import '../../../sync/services/sync_service.dart';
import '../../data/datasources/grabacion_remote_datasource.dart';
import '../../data/datasources/grabacion_remote_datasource_impl.dart';
import '../../data/repositories/grabacion_repository_impl.dart';
import '../../data/services/audio_recorder_service.dart';
import '../../domain/repositories/grabacion_repository.dart';
import '../../domain/usecases/grabacion_usecases.dart';

part 'recording_providers.g.dart';

/// Cadena de dependencias de grabaciones como providers de Riverpod
/// (composición declarativa). Reemplaza el registro get_it de esta feature.

@Riverpod(keepAlive: true)
GrabacionRemoteDataSource grabacionRemoteDataSource(
        Ref ref) =>
    GrabacionRemoteDataSourceImpl(
      ref.watch(apiClientProvider),
      ref.watch(tokenStorageProvider),
    );

@Riverpod(keepAlive: true)
GrabacionRepository grabacionRepository(Ref ref) =>
    GrabacionRepositoryImpl(ref.watch(grabacionRemoteDataSourceProvider));

@riverpod
ObtenerGrabacionUseCase obtenerGrabacionUseCase(
        Ref ref) =>
    ObtenerGrabacionUseCase(ref.watch(grabacionRepositoryProvider));

@riverpod
CalcularMetrosUseCase calcularMetrosUseCase(Ref ref) =>
    CalcularMetrosUseCase(ref.watch(grabacionRepositoryProvider));

@riverpod
ActualizarTranscripcionUseCase actualizarTranscripcionUseCase(
        Ref ref) =>
    ActualizarTranscripcionUseCase(ref.watch(grabacionRepositoryProvider));

@riverpod
SubirGrabacionUseCase subirGrabacionUseCase(Ref ref) =>
    SubirGrabacionUseCase(ref.watch(grabacionRepositoryProvider));

// --- Servicios de grabación / sincronización (construidos nativamente) ---

@Riverpod(keepAlive: true)
AudioRecorderService audioRecorderService(Ref ref) =>
    AudioRecorderService();

@Riverpod(keepAlive: true)
SyncLocalDataSource syncLocalDataSource(Ref ref) =>
    SyncLocalDataSource(ref.watch(localDatabaseProvider));

@Riverpod(keepAlive: true)
SyncService syncService(Ref ref) => SyncService(
      ref.watch(syncLocalDataSourceProvider),
      ref.watch(apiClientProvider),
      ref.watch(tokenStorageProvider),
      ref.watch(localDatabaseProvider),
    );
