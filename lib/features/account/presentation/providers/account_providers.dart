import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/infra_providers.dart';
import '../../data/datasources/account_remote_datasource.dart';
import '../../data/datasources/account_remote_datasource_impl.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/usecases/account_usecases.dart';

part 'account_providers.g.dart';

/// Cadena de dependencias de cuenta/suscripciones como providers de Riverpod.

@Riverpod(keepAlive: true)
AccountRemoteDataSource accountRemoteDataSource(
        AccountRemoteDataSourceRef ref) =>
    AccountRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
AccountRepository accountRepository(AccountRepositoryRef ref) =>
    AccountRepositoryImpl(ref.watch(accountRemoteDataSourceProvider));

@riverpod
ObtenerSuscripcionesUseCase obtenerSuscripcionesUseCase(
        ObtenerSuscripcionesUseCaseRef ref) =>
    ObtenerSuscripcionesUseCase(ref.watch(accountRepositoryProvider));
