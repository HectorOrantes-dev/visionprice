import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../data/services/audio_recorder_service.dart';
import '../../domain/usecases/grabacion_usecases.dart';

/// Estados de la pantalla de grabación:
/// - [idle] → sin grabar.
/// - [recording] → capturando audio.
/// - [recorded] → audio listo para subir.
/// - [uploading] → subiendo al back-end.
/// - [error] → ver [errorMessage].
enum RecordState { idle, recording, recorded, uploading, error }

/// ViewModel de la grabación. `@injectable`: recibe el servicio de audio y el
/// caso de uso de subida. Captura audio real y lo sube como multipart.
@injectable
class RecordingViewModel extends ChangeNotifier {
  final AudioRecorderService _recorder;
  final SubirGrabacionUseCase _subir;
  final ConnectivityService _connectivity;

  RecordingViewModel(this._recorder, this._subir, this._connectivity) {
    checkConnectivity();
  }

  RecordState _state = RecordState.idle;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  String? _audioPath;
  String? _errorMessage;
  bool? _online; // null = verificando

  RecordState get state => _state;
  Duration get elapsed => _elapsed;
  bool get isRecording => _state == RecordState.recording;
  bool get isUploading => _state == RecordState.uploading;
  bool get hasRecording => _state == RecordState.recorded;
  String? get errorMessage => _errorMessage;

  /// `null` mientras verifica, luego `true`/`false` según conectividad real.
  bool? get online => _online;
  bool get isOffline => _online == false;

  /// Verifica conexión real (ping al back-end) y actualiza el estado.
  Future<void> checkConnectivity() async {
    _online = await _connectivity.isOnline();
    notifyListeners();
  }

  String get elapsedFormatted {
    final m = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> startRecording() async {
    final allowed = await _recorder.hasPermission();
    if (!allowed) {
      _state = RecordState.error;
      _errorMessage = 'Necesitamos permiso de micrófono para grabar.';
      notifyListeners();
      return;
    }
    await _recorder.start();
    _state = RecordState.recording;
    _elapsed = Duration.zero;
    _errorMessage = null;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += const Duration(seconds: 1);
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> stopRecording() async {
    _timer?.cancel();
    _audioPath = await _recorder.stop();
    _state = _audioPath != null ? RecordState.recorded : RecordState.idle;
    notifyListeners();
  }

  /// Sube el audio grabado. Invoca [onUploaded] con el id de la grabación
  /// (estado "procesando") para pasar a la pantalla de procesamiento.
  Future<void> upload({required void Function(int grabacionId) onUploaded}) async {
    if (_audioPath == null) return;
    _state = RecordState.uploading;
    _errorMessage = null;
    notifyListeners();
    try {
      final grabacion = await _subir(
        audioPath: _audioPath!,
        duracionSegundos: _elapsed.inSeconds,
      );
      onUploaded(grabacion.id);
    } catch (e) {
      _state = RecordState.error;
      _errorMessage =
          e is ApiException ? e.message : 'No se pudo subir la grabación.';
      notifyListeners();
      // Si fue error de red, refresca el estado de conexión del chip.
      if (e is ApiException && e.isNetwork) checkConnectivity();
    }
  }

  Future<void> retry() async {
    _timer?.cancel();
    await _recorder.cancel();
    _audioPath = null;
    _elapsed = Duration.zero;
    _state = RecordState.idle;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
