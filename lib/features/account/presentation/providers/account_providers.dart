import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/api_client_provider.dart';
import '../../data/datasources/account_remote_datasource.dart';
import '../../data/datasources/account_remote_datasource_impl.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/usecases/account_usecases.dart';

part 'account_providers.g.dart';

/// Cadena de dependencias de cuenta/suscripciones como providers de Riverpod.

@Riverpod(keepAlive: true)
AccountRemoteDataSource accountRemoteDataSource(Ref ref) =>
    AccountRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) =>
    AccountRepositoryImpl(ref.watch(accountRemoteDataSourceProvider));

@riverpod
ObtenerSuscripcionesUseCase obtenerSuscripcionesUseCase(Ref ref) =>
    ObtenerSuscripcionesUseCase(ref.watch(accountRepositoryProvider));

@riverpod
CrearSuscripcionConektaUseCase crearSuscripcionConektaUseCase(Ref ref) =>
    CrearSuscripcionConektaUseCase(ref.watch(accountRepositoryProvider));

@riverpod
CancelarSuscripcionConektaUseCase cancelarSuscripcionConektaUseCase(Ref ref) =>
    CancelarSuscripcionConektaUseCase(ref.watch(accountRepositoryProvider));

@riverpod
EliminarMetodoPagoConektaUseCase eliminarMetodoPagoConektaUseCase(Ref ref) =>
    EliminarMetodoPagoConektaUseCase(ref.watch(accountRepositoryProvider));

@riverpod
CrearCheckoutConektaUseCase crearCheckoutConektaUseCase(Ref ref) =>
    CrearCheckoutConektaUseCase(ref.watch(accountRepositoryProvider));

@riverpod
CrearSuscripcionPaypalUseCase crearSuscripcionPaypalUseCase(Ref ref) =>
    CrearSuscripcionPaypalUseCase(ref.watch(accountRepositoryProvider));

@riverpod
CancelarSuscripcionPaypalUseCase cancelarSuscripcionPaypalUseCase(Ref ref) =>
    CancelarSuscripcionPaypalUseCase(ref.watch(accountRepositoryProvider));
