import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Envuelve el plugin `record` para capturar el audio del maestro de obra.
/// `@lazySingleton`: una sola instancia que mantiene el estado del grabador
/// (un recurso del sistema → buen candidato a singleton).
class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _path;

  /// Ruta del último archivo grabado (o `null` si no hay).
  String? get path => _path;

  /// Pide/verifica el permiso de micrófono.
  Future<bool> hasPermission() => _recorder.hasPermission();

  /// Inicia la grabación a un archivo temporal `.m4a` (AAC).
  Future<void> start() async {
    final dir = await getTemporaryDirectory();
    _path =
        '${dir.path}/grabacion_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: _path!,
    );
  }

  /// Detiene la grabación y devuelve la ruta final del archivo.
  Future<String?> stop() async {
    _path = await _recorder.stop();
    return _path;
  }

  /// Cancela y descarta el archivo en curso.
  Future<void> cancel() async {
    await _recorder.cancel();
    _path = null;
  }

  Future<bool> isRecording() => _recorder.isRecording();

  /// Stream para el visualizador de audio (ondas).
  Stream<Amplitude> get onAmplitudeChanged =>
      _recorder.onAmplitudeChanged(const Duration(milliseconds: 100));

  Future<void> dispose() => _recorder.dispose();
}
