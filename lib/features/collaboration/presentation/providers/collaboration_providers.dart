import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/api_client_provider.dart';
import '../../data/datasources/collaboration_remote_datasource.dart';
import '../../data/repositories/collaboration_repository_impl.dart';
import '../../domain/entities/invitacion_entity.dart';
import '../../domain/entities/miembros_result_entity.dart';
import '../../domain/entities/unirse_result_entity.dart';
import '../../domain/repositories/collaboration_repository.dart';
import '../../domain/usecases/generar_invitacion_usecase.dart';
import '../../domain/usecases/obtener_invitaciones_usecase.dart';
import '../../domain/usecases/obtener_miembros_usecase.dart';
import '../../domain/usecases/quitar_miembro_usecase.dart';
import '../../domain/usecases/revocar_invitacion_usecase.dart';
import '../../domain/usecases/unirse_a_proyecto_usecase.dart';

part 'collaboration_providers.g.dart';

// --- Data Layer ---

@Riverpod(keepAlive: true)
CollaborationRemoteDataSource collaborationRemoteDataSource(Ref ref) {
  return CollaborationRemoteDataSourceImpl(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
CollaborationRepository collaborationRepository(Ref ref) {
  return CollaborationRepositoryImpl(ref.watch(collaborationRemoteDataSourceProvider));
}

// --- Use Cases ---

@riverpod
ObtenerMiembrosUseCase obtenerMiembrosUseCase(Ref ref) =>
    ObtenerMiembrosUseCase(ref.watch(collaborationRepositoryProvider));

@riverpod
QuitarMiembroUseCase quitarMiembroUseCase(Ref ref) =>
    QuitarMiembroUseCase(ref.watch(collaborationRepositoryProvider));

@riverpod
GenerarInvitacionUseCase generarInvitacionUseCase(Ref ref) =>
    GenerarInvitacionUseCase(ref.watch(collaborationRepositoryProvider));

@riverpod
ObtenerInvitacionesUseCase obtenerInvitacionesUseCase(Ref ref) =>
    ObtenerInvitacionesUseCase(ref.watch(collaborationRepositoryProvider));

@riverpod
RevocarInvitacionUseCase revocarInvitacionUseCase(Ref ref) =>
    RevocarInvitacionUseCase(ref.watch(collaborationRepositoryProvider));

@riverpod
UnirseAProyectoUseCase unirseAProyectoUseCase(Ref ref) =>
    UnirseAProyectoUseCase(ref.watch(collaborationRepositoryProvider));

// --- State Notifiers ---

@riverpod
class MiembrosNotifier extends _$MiembrosNotifier {
  @override
  Future<MiembrosResultEntity> build(int proyectoId) async {
    return _fetch();
  }

  Future<MiembrosResultEntity> _fetch() async {
    final useCase = ref.read(obtenerMiembrosUseCaseProvider);
    final result = await useCase(proyectoId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  Future<void> recargar() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> quitarMiembro(int usuarioId) async {
    final useCase = ref.read(quitarMiembroUseCaseProvider);
    final result = await useCase(proyectoId, usuarioId);
    result.fold(
      (failure) => throw Exception(failure.message), // Manejar en UI
      (_) => recargar(), // Recargar la lista después de quitar
    );
  }
}

@riverpod
class InvitacionesNotifier extends _$InvitacionesNotifier {
  @override
  Future<List<InvitacionEntity>> build(int proyectoId) async {
    return _fetch();
  }

  Future<List<InvitacionEntity>> _fetch() async {
    final useCase = ref.read(obtenerInvitacionesUseCaseProvider);
    final result = await useCase(proyectoId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  Future<void> recargar() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> revocar(int invitacionId) async {
    final useCase = ref.read(revocarInvitacionUseCaseProvider);
    final result = await useCase(proyectoId, invitacionId);
    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => recargar(),
    );
  }
}

@riverpod
class UnirseAProyectoNotifier extends _$UnirseAProyectoNotifier {
  @override
  AsyncValue<UnirseResultEntity?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> unirse(String codigo) async {
    state = const AsyncValue.loading();
    final useCase = ref.read(unirseAProyectoUseCaseProvider);
    final result = await useCase(codigo);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (data) => AsyncValue.data(data),
    );
  }
}

@riverpod
class GenerarInvitacionNotifier extends _$GenerarInvitacionNotifier {
  @override
  AsyncValue<InvitacionEntity?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> generar(int proyectoId, String rol, {List<String>? correos}) async {
    state = const AsyncValue.loading();
    final useCase = ref.read(generarInvitacionUseCaseProvider);
    final result = await useCase(proyectoId, rol, correos: correos);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (data) => AsyncValue.data(data),
    );
  }
}
