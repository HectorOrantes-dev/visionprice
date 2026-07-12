import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/api_client_provider.dart';
import '../../data/datasources/cotizacion_remote_datasource.dart';
import '../../data/datasources/cotizacion_remote_datasource_impl.dart';
import '../../data/repositories/cotizacion_repository_impl.dart';
import '../../domain/repositories/cotizacion_repository.dart';
import '../../domain/usecases/cotizacion_usecases.dart';
import '../../domain/usecases/crear_cotizacion_kit_use_case.dart';
import '../../domain/usecases/obtener_materiales_use_case.dart';

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

@riverpod
ObtenerMaterialesUseCase obtenerMaterialesUseCase(
        ObtenerMaterialesUseCaseRef ref) =>
    ObtenerMaterialesUseCase(ref.watch(cotizacionRepositoryProvider));

@riverpod
CrearCotizacionKitUseCase crearCotizacionKitUseCase(
        CrearCotizacionKitUseCaseRef ref) =>
    CrearCotizacionKitUseCase(ref.watch(cotizacionRepositoryProvider));
