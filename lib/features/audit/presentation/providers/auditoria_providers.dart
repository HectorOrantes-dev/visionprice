import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/api_client_provider.dart';
import '../../data/datasources/auditoria_remote_datasource.dart';
import '../../data/datasources/auditoria_remote_datasource_impl.dart';
import '../../data/repositories/auditoria_repository_impl.dart';
import '../../domain/repositories/auditoria_repository.dart';
import '../../domain/usecases/auditoria_usecases.dart';

part 'auditoria_providers.g.dart';

@Riverpod(keepAlive: true)
AuditoriaRemoteDataSource auditoriaRemoteDataSource(Ref ref) =>
    AuditoriaRemoteDataSourceImpl(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
AuditoriaRepository auditoriaRepository(Ref ref) =>
    AuditoriaRepositoryImpl(ref.watch(auditoriaRemoteDataSourceProvider));

@riverpod
AuditarPresupuestoUseCase auditarPresupuestoUseCase(Ref ref) =>
    AuditarPresupuestoUseCase(ref.watch(auditoriaRepositoryProvider));

@riverpod
ObtenerAnomaliasZonaUseCase obtenerAnomaliasZonaUseCase(Ref ref) =>
    ObtenerAnomaliasZonaUseCase(ref.watch(auditoriaRepositoryProvider));
