import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/notificacion_entity.dart';
import 'notificacion_providers.dart';

part 'notifications_provider.g.dart';

/// Estado inmutable de la lista de notificaciones.
class NotificationsState {
  final bool loading;
  final String? errorMessage;
  final List<NotificacionEntity> items;

  const NotificationsState({
    this.loading = true,
    this.errorMessage,
    this.items = const [],
  });

  int get noLeidas => items.where((n) => !n.leida).length;

  static const _keep = Object();

  NotificationsState copyWith({
    bool? loading,
    Object? errorMessage = _keep,
    List<NotificacionEntity>? items,
  }) {
    return NotificationsState(
      loading: loading ?? this.loading,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      items: items ?? this.items,
    );
  }
}

/// Notifier de notificaciones (Riverpod moderno). Reemplaza al
/// `NotificationsViewModel` (ChangeNotifier).
@riverpod
class Notifications extends _$Notifications {
  @override
  NotificationsState build() {
    // `load` muta `state` en su primera línea síncrona → se difiere para no
    // mutar el estado mientras el propio build() se construye.
    Future.microtask(load);
    return const NotificationsState();
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final items = await ref.read(obtenerNotificacionesUseCaseProvider)();
      state = state.copyWith(items: items, loading: false);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage: e is ApiException
            ? e.message
            : 'No se pudieron cargar las notificaciones.',
      );
    }
  }

  /// Marca como leída (optimista: actualiza la UI y llama al back-end).
  Future<void> marcarLeida(int id) async {
    final i = state.items.indexWhere((n) => n.id == id);
    if (i == -1 || state.items[i].leida) return;
    final original = state.items[i];
    final optimista = List<NotificacionEntity>.from(state.items)
      ..[i] = original.copyWith(leida: true);
    state = state.copyWith(items: optimista);
    try {
      await ref.read(marcarNotificacionLeidaUseCaseProvider)(id);
    } catch (_) {
      // Revertir si falla.
      final revert = List<NotificacionEntity>.from(state.items)..[i] = original;
      state = state.copyWith(items: revert);
    }
  }
}
