import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/notificacion_entity.dart';
import '../../domain/usecases/notificacion_usecases.dart';

@injectable
class NotificationsViewModel extends ChangeNotifier {
  final ObtenerNotificacionesUseCase _obtener;
  final MarcarNotificacionLeidaUseCase _marcarLeida;

  NotificationsViewModel(this._obtener, this._marcarLeida) {
    load();
  }

  bool _loading = true;
  String? _errorMessage;
  List<NotificacionEntity> _items = const [];

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  List<NotificacionEntity> get items => _items;
  int get noLeidas => _items.where((n) => !n.leida).length;

  Future<void> load() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _items = await _obtener();
    } catch (e) {
      _errorMessage = e is ApiException
          ? e.message
          : 'No se pudieron cargar las notificaciones.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Marca como leída (optimista: actualiza la UI y llama al back-end).
  Future<void> marcarLeida(int id) async {
    final i = _items.indexWhere((n) => n.id == id);
    if (i == -1 || _items[i].leida) return;
    _items[i] = _items[i].copyWith(leida: true);
    notifyListeners();
    try {
      await _marcarLeida(id);
    } catch (_) {
      // Revertir si falla.
      _items[i] = _items[i].copyWith(leida: false);
      notifyListeners();
    }
  }
}
