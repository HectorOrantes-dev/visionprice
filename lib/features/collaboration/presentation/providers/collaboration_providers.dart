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
  return CollaborationRepositoryImpl(
      ref.watch(collaborationRemoteDataSourceProvider));
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

  Future<MiembrosResultEntity> _fetch() =>
      ref.read(obtenerMiembrosUseCaseProvider)(proyectoId);

  Future<void> recargar() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Quita un miembro y refresca la lista. Lanza si falla (la UI lo captura).
  Future<void> quitarMiembro(int usuarioId) async {
    await ref.read(quitarMiembroUseCaseProvider)(proyectoId, usuarioId);
    await recargar();
  }
}

@riverpod
class InvitacionesNotifier extends _$InvitacionesNotifier {
  @override
  Future<List<InvitacionEntity>> build(int proyectoId) async {
    return _fetch();
  }

  Future<List<InvitacionEntity>> _fetch() =>
      ref.read(obtenerInvitacionesUseCaseProvider)(proyectoId);

  Future<void> recargar() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Revoca un código y refresca la lista. Lanza si falla (la UI lo captura).
  Future<void> revocar(int invitacionId) async {
    await ref.read(revocarInvitacionUseCaseProvider)(proyectoId, invitacionId);
    await recargar();
  }
}

@riverpod
class UnirseAProyectoNotifier extends _$UnirseAProyectoNotifier {
  @override
  FutureOr<UnirseResultEntity?> build() => null;

  /// Une al usuario al proyecto con [codigo]. `guard` traduce el resultado o el
  /// error del back-end (código inválido/expirado) al subtipo de `AsyncValue`.
  Future<void> unirse(String codigo) async {
    state = const AsyncLoading<UnirseResultEntity?>();
    state = await AsyncValue.guard<UnirseResultEntity?>(
      () => ref.read(unirseAProyectoUseCaseProvider)(codigo),
    );
  }
}

@riverpod
class GenerarInvitacionNotifier extends _$GenerarInvitacionNotifier {
  @override
  FutureOr<InvitacionEntity?> build() => null;

  Future<void> generar(int proyectoId, String rol,
      {List<String>? correos}) async {
    state = const AsyncLoading<InvitacionEntity?>();
    state = await AsyncValue.guard<InvitacionEntity?>(
      () => ref.read(generarInvitacionUseCaseProvider)(
        proyectoId,
        rol,
        correos: correos,
      ),
    );
  }
}
