import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/api_client_provider.dart';
import '../../data/datasources/notificacion_remote_datasource.dart';
import '../../data/datasources/notificacion_remote_datasource_impl.dart';
import '../../data/repositories/notificacion_repository_impl.dart';
import '../../domain/repositories/notificacion_repository.dart';
import '../../domain/usecases/notificacion_usecases.dart';

part 'notificacion_providers.g.dart';

/// Cadena de dependencias de notificaciones como providers de Riverpod.

@Riverpod(keepAlive: true)
NotificacionRemoteDataSource notificacionRemoteDataSource(Ref ref) =>
    NotificacionRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
NotificacionRepository notificacionRepository(Ref ref) =>
    NotificacionRepositoryImpl(ref.watch(notificacionRemoteDataSourceProvider));

@riverpod
ObtenerNotificacionesUseCase obtenerNotificacionesUseCase(Ref ref) =>
    ObtenerNotificacionesUseCase(ref.watch(notificacionRepositoryProvider));

@riverpod
MarcarNotificacionLeidaUseCase marcarNotificacionLeidaUseCase(Ref ref) =>
    MarcarNotificacionLeidaUseCase(ref.watch(notificacionRepositoryProvider));
