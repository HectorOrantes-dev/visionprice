import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/infra_providers.dart';
import '../../data/datasources/notificacion_remote_datasource.dart';
import '../../data/datasources/notificacion_remote_datasource_impl.dart';
import '../../data/repositories/notificacion_repository_impl.dart';
import '../../domain/repositories/notificacion_repository.dart';
import '../../domain/usecases/notificacion_usecases.dart';

part 'notificacion_providers.g.dart';

/// Cadena de dependencias de notificaciones como providers de Riverpod.

@Riverpod(keepAlive: true)
NotificacionRemoteDataSource notificacionRemoteDataSource(
        NotificacionRemoteDataSourceRef ref) =>
    NotificacionRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
NotificacionRepository notificacionRepository(
        NotificacionRepositoryRef ref) =>
    NotificacionRepositoryImpl(ref.watch(notificacionRemoteDataSourceProvider));

@riverpod
ObtenerNotificacionesUseCase obtenerNotificacionesUseCase(
        ObtenerNotificacionesUseCaseRef ref) =>
    ObtenerNotificacionesUseCase(ref.watch(notificacionRepositoryProvider));

@riverpod
MarcarNotificacionLeidaUseCase marcarNotificacionLeidaUseCase(
        MarcarNotificacionLeidaUseCaseRef ref) =>
    MarcarNotificacionLeidaUseCase(ref.watch(notificacionRepositoryProvider));
