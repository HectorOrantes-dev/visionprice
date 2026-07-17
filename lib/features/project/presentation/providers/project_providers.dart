import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/api_client_provider.dart';
import '../../../../core/di/local_database_provider.dart';
import '../../data/datasources/proyecto_remote_datasource.dart';
import '../../data/datasources/proyecto_remote_datasource_impl.dart';
import '../../data/repositories/proyecto_repository_impl.dart';
import '../../domain/repositories/proyecto_repository.dart';
import '../../domain/usecases/proyecto_usecases.dart';

part 'project_providers.g.dart';

/// Cadena de dependencias de proyectos como providers de Riverpod.

@Riverpod(keepAlive: true)
ProyectoRemoteDataSource proyectoRemoteDataSource(
        Ref ref) =>
    ProyectoRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
ProyectoRepository proyectoRepository(Ref ref) =>
    ProyectoRepositoryImpl(
      ref.watch(proyectoRemoteDataSourceProvider),
      ref.watch(localDatabaseProvider),
    );

@riverpod
ObtenerProyectosUseCase obtenerProyectosUseCase(
        Ref ref) =>
    ObtenerProyectosUseCase(ref.watch(proyectoRepositoryProvider));

@riverpod
CrearProyectoUseCase crearProyectoUseCase(Ref ref) =>
    CrearProyectoUseCase(ref.watch(proyectoRepositoryProvider));

@riverpod
ActualizarUbicacionProyectoUseCase actualizarUbicacionProyectoUseCase(
        Ref ref) =>
    ActualizarUbicacionProyectoUseCase(ref.watch(proyectoRepositoryProvider));
