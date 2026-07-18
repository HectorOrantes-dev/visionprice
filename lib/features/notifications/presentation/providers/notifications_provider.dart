import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/notificacion_entity.dart';
import 'notificacion_providers.dart';

part 'notifications_provider.g.dart';

/// AsyncNotifier de la lista de notificaciones. `build()` carga la lista y
/// Riverpod la expone como `AsyncValue<List<NotificacionEntity>>`. La UI la
/// consume con `.when()`.
@riverpod
class Notifications extends _$Notifications {
  @override
  Future<List<NotificacionEntity>> build() =>
      ref.read(obtenerNotificacionesUseCaseProvider)();

  /// Marca como leída de forma optimista: actualiza la UI al instante y
  /// revierte si el back-end falla. Opera sobre el valor actual del AsyncData.
  Future<void> marcarLeida(int id) async {
    final actuales = state.asData?.value;
    if (actuales == null) return;
    final i = actuales.indexWhere((n) => n.id == id);
    if (i == -1 || actuales[i].leida) return;

    final original = actuales[i];
    final optimista = List<NotificacionEntity>.from(actuales)
      ..[i] = original.copyWith(leida: true);
    state = AsyncData(optimista);
    try {
      await ref.read(marcarNotificacionLeidaUseCaseProvider)(id);
    } catch (_) {
      // Revertir si falla (sobre la lista actual, por si cambió mientras tanto).
      final ahora = state.asData?.value ?? optimista;
      final j = ahora.indexWhere((n) => n.id == id);
      if (j != -1) {
        state = AsyncData(List<NotificacionEntity>.from(ahora)..[j] = original);
      }
    }
  }
}
