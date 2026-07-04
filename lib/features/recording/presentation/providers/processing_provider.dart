import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/grabacion_entity.dart';
import '../../domain/usecases/grabacion_usecases.dart';

/// ViewModel de la pantalla "Procesando". Sondea `GET /grabaciones/{id}` de
/// forma SERIALIZADA (una petición a la vez) cada ~4 s mientras el estado sea
/// "procesando", hasta que pase a "sincronizado" (listo, con transcripción) o
/// "error". Tiene un tope de intentos para no sondear indefinidamente y respeta
/// un backoff ante un 429.
@injectable
class ProcessingViewModel extends ChangeNotifier {
  final ObtenerGrabacionUseCase _obtener;
  ProcessingViewModel(this._obtener);

  /// Intervalo normal entre sondeos.
  static const Duration _interval = Duration(seconds: 4);

  /// Espera más larga cuando el back responde 429 (demasiadas peticiones).
  static const Duration _backoff429 = Duration(seconds: 15);

  /// Tope de intentos (~3 min a 4 s) antes de rendirse y avisar al usuario.
  static const int _maxAttempts = 45;

  GrabacionEntity? _grabacion;
  bool _started = false;
  bool _disposed = false;
  bool _timedOut = false;

  GrabacionEntity? get grabacion => _grabacion;
  bool get isProcessing => _grabacion?.isProcesando ?? true;
  bool get isDone => _grabacion?.isSincronizado ?? false;
  bool get hasError => _grabacion?.isError ?? false;

  /// `true` si se agotó el tope de intentos sin llegar a un estado terminal.
  bool get timedOut => _timedOut;

  /// Arranca el sondeo para la grabación [id]. Idempotente: garantiza un ÚNICO
  /// poller aunque se llame varias veces.
  void start(int id) {
    if (_started) return;
    _started = true;
    _pollLoop(id);
  }

  /// Bucle serializado: espera a que termine cada petición antes de programar
  /// la siguiente. Evita pollers concurrentes que apilan peticiones (el bug de
  /// múltiples conexiones simultáneas). Se corta al llegar a un estado terminal,
  /// al agotar el tope de intentos o cuando la pantalla se destruye ([dispose]).
  Future<void> _pollLoop(int id) async {
    var attempts = 0;
    while (!_disposed) {
      var wait = _interval;
      try {
        final g = await _obtener(id);
        if (_disposed) return;
        _grabacion = g;
        notifyListeners();
        // Estado terminal → deja de sondear.
        if (g.isSincronizado || g.isError) return;
      } on ApiException catch (e) {
        if (_disposed) return;
        // 429: el back pide calma → espera más antes de reintentar.
        if (e.isTooManyRequests) wait = _backoff429;
        // Otros errores (red/timeout): reintenta en el próximo tick.
      } catch (_) {
        if (_disposed) return;
      }

      if (++attempts >= _maxAttempts) {
        _timedOut = true;
        notifyListeners();
        return; // Tope alcanzado → para; la UI muestra "vuelve más tarde".
      }

      await Future.delayed(wait);
    }
  }

  @override
  void dispose() {
    _disposed = true; // Corta el bucle en el próximo `await`.
    super.dispose();
  }
}
