import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/infra_providers.dart';
import '../../data/datasources/cotizacion_remote_datasource.dart';
import '../../data/datasources/cotizacion_remote_datasource_impl.dart';
import '../../data/repositories/cotizacion_repository_impl.dart';
import '../../domain/repositories/cotizacion_repository.dart';
import '../../domain/usecases/cotizacion_usecases.dart';

part 'budget_providers.g.dart';

/// Cadena de dependencias de cotizaciones como providers de Riverpod.

@Riverpod(keepAlive: true)
CotizacionRemoteDataSource cotizacionRemoteDataSource(
        CotizacionRemoteDataSourceRef ref) =>
    CotizacionRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
CotizacionRepository cotizacionRepository(CotizacionRepositoryRef ref) =>
    CotizacionRepositoryImpl(ref.watch(cotizacionRemoteDataSourceProvider));

@riverpod
ObtenerProductosUseCase obtenerProductosUseCase(
        ObtenerProductosUseCaseRef ref) =>
    ObtenerProductosUseCase(ref.watch(cotizacionRepositoryProvider));

@riverpod
CrearCotizacionUseCase crearCotizacionUseCase(CrearCotizacionUseCaseRef ref) =>
    CrearCotizacionUseCase(ref.watch(cotizacionRepositoryProvider));

@riverpod
ObtenerPdfUseCase obtenerPdfUseCase(ObtenerPdfUseCaseRef ref) =>
    ObtenerPdfUseCase(ref.watch(cotizacionRepositoryProvider));
