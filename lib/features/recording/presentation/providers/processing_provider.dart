import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/grabacion_entity.dart';
import '../../domain/usecases/grabacion_usecases.dart';

/// ViewModel de la pantalla "Procesando". Sondea `GET /grabaciones/{id}` cada
/// ~4 s mientras el estado es "procesando", hasta que pase a "sincronizado"
/// (listo, con transcripción) o "error".
@injectable
class ProcessingViewModel extends ChangeNotifier {
  final ObtenerGrabacionUseCase _obtener;
  ProcessingViewModel(this._obtener);

  static const Duration _interval = Duration(seconds: 4);

  GrabacionEntity? _grabacion;
  Timer? _timer;
  bool _started = false;

  GrabacionEntity? get grabacion => _grabacion;
  bool get isProcessing => _grabacion?.isProcesando ?? true;
  bool get isDone => _grabacion?.isSincronizado ?? false;
  bool get hasError => _grabacion?.isError ?? false;

  /// Arranca el sondeo para la grabación [id]. Idempotente.
  void start(int id) {
    if (_started) return;
    _started = true;
    _poll(id);
    _timer = Timer.periodic(_interval, (_) => _poll(id));
  }

  Future<void> _poll(int id) async {
    try {
      final g = await _obtener(id);
      _grabacion = g;
      if (g.isSincronizado || g.isError) {
        _timer?.cancel();
      }
      notifyListeners();
    } catch (_) {
      // Error transitorio de red: seguimos sondeando en el próximo tick.
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
