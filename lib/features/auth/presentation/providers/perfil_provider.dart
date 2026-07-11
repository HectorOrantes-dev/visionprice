import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/perfil_entity.dart';
import 'auth_providers.dart';

part 'perfil_provider.g.dart';

/// Estado de la pantalla de Perfil.
enum PerfilStatus { loading, success, error }

class PerfilState {
  final PerfilStatus status;
  final String? errorMessage;
  final PerfilEntity? perfil;

  const PerfilState({
    this.status = PerfilStatus.loading,
    this.errorMessage,
    this.perfil,
  });

  bool get isLoading => status == PerfilStatus.loading;

  static const _keep = Object();

  PerfilState copyWith({
    PerfilStatus? status,
    Object? errorMessage = _keep,
    Object? perfil = _keep,
  }) {
    return PerfilState(
      status: status ?? this.status,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      perfil: perfil == _keep ? this.perfil : perfil as PerfilEntity?,
    );
  }
}

/// Notifier de la pantalla "Perfil" (Riverpod moderno). Carga el perfil
/// (`GET /api/v1/me/perfil`) al observarse. Reemplaza al `PerfilViewModel`.
@riverpod
class Perfil extends _$Perfil {
  @override
  PerfilState build() {
    load();
    return const PerfilState();
  }

  /// Carga el perfil. Tras la primera vez viene de la caché del repositorio
  /// (sin pegar a la red). Usa [forceRefresh] para forzar una recarga real.
  Future<void> load({bool forceRefresh = false}) async {
    state = state.copyWith(status: PerfilStatus.loading, errorMessage: null);
    try {
      final perfil =
          await ref.read(getPerfilUseCaseProvider)(forceRefresh: forceRefresh);
      state = state.copyWith(status: PerfilStatus.success, perfil: perfil);
    } catch (e) {
      state = state.copyWith(
        status: PerfilStatus.error,
        errorMessage:
            e is ApiException ? e.message : 'No se pudo cargar el perfil',
      );
    }
  }

  /// Fuerza una recarga desde el back-end (p. ej. pull-to-refresh).
  Future<void> refresh() => load(forceRefresh: true);
}
