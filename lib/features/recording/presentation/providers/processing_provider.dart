import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/grabacion_entity.dart';
import 'recording_providers.dart';

part 'processing_provider.g.dart';

/// Estado inmutable de la pantalla "Procesando".
class ProcessingState {
  final GrabacionEntity? grabacion;

  /// `true` si se agotó el tope de intentos sin llegar a un estado terminal.
  final bool timedOut;

  const ProcessingState({this.grabacion, this.timedOut = false});

  bool get isProcessing => grabacion?.isProcesando ?? true;
  bool get isDone => grabacion?.isSincronizado ?? false;
  bool get hasError => grabacion?.isError ?? false;

  ProcessingState copyWith({GrabacionEntity? grabacion, bool? timedOut}) =>
      ProcessingState(
        grabacion: grabacion ?? this.grabacion,
        timedOut: timedOut ?? this.timedOut,
      );
}

/// Notifier `.family` (parametrizado por `grabacionId`) que sondea
/// `GET /grabaciones/{id}` de forma SERIALIZADA cada ~4 s mientras el estado
/// sea "procesando", hasta "sincronizado"/"error", con tope de intentos y
/// backoff ante 429. Reemplaza al antiguo `ProcessingViewModel` (ChangeNotifier).
///
/// El sondeo arranca solo en `build()` (una vez) y se corta cuando el provider
/// se elimina (autoDispose al salir de la pantalla) vía `ref.onDispose`.
@riverpod
class Processing extends _$Processing {
  static const Duration _interval = Duration(seconds: 4);
  static const Duration _backoff429 = Duration(seconds: 15);
  static const int _maxAttempts = 45; // ~3 min a 4 s

  bool _disposed = false;

  @override
  ProcessingState build(int grabacionId) {
    ref.onDispose(() => _disposed = true);
    _pollLoop(grabacionId);
    return const ProcessingState();
  }

  Future<void> _pollLoop(int id) async {
    var attempts = 0;
    while (!_disposed) {
      var wait = _interval;
      try {
        final g = await ref.read(obtenerGrabacionUseCaseProvider)(id);
        if (_disposed) return;
        state = state.copyWith(grabacion: g);
        if (g.isSincronizado || g.isError) return; // estado terminal → fin
      } on ApiException catch (e) {
        if (_disposed) return;
        if (e.isTooManyRequests) wait = _backoff429; // 429 → espera más
      } catch (_) {
        if (_disposed) return;
      }

      if (++attempts >= _maxAttempts) {
        state = state.copyWith(timedOut: true);
        return; // tope alcanzado → para; la UI muestra "vuelve más tarde"
      }

      await Future.delayed(wait);
    }
  }
}
