import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/api_client_provider.dart';
import '../../data/datasources/recomendacion_remote_datasource.dart';
import '../../data/datasources/recomendacion_remote_datasource_impl.dart';
import '../../data/repositories/recomendacion_repository_impl.dart';
import '../../domain/repositories/recomendacion_repository.dart';
import '../../domain/usecases/entrenar_modelos_use_case.dart';
import '../../domain/usecases/obtener_recomendacion_kit_use_case.dart';

part 'recomendacion_providers.g.dart';

/// Cadena de dependencias de recomendaciones como providers de Riverpod.

@Riverpod(keepAlive: true)
RecomendacionRemoteDataSource recomendacionRemoteDataSource(Ref ref) =>
    RecomendacionRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
RecomendacionRepository recomendacionRepository(Ref ref) =>
    RecomendacionRepositoryImpl(ref.watch(recomendacionRemoteDataSourceProvider));

@riverpod
EntrenarModelosUseCase entrenarModelosUseCase(Ref ref) =>
    EntrenarModelosUseCase(ref.watch(recomendacionRepositoryProvider));

@riverpod
ObtenerRecomendacionKitUseCase obtenerRecomendacionKitUseCase(Ref ref) =>
    ObtenerRecomendacionKitUseCase(ref.watch(recomendacionRepositoryProvider));
