import 'dart:async';

import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/infra_providers.dart';
import '../../../../core/network/api_exception.dart';
import '../../../project/domain/entities/proyecto_entity.dart';
import '../../../project/presentation/providers/project_providers.dart';
import 'recording_providers.dart';
import 'recording_state.dart';

export 'recording_state.dart';

part 'recording_provider.g.dart';

/// Notifier de la grabación (Riverpod moderno). Reemplaza al `RecordingViewModel`
/// (ChangeNotifier): captura audio real y lo sube como multipart, o lo encola
/// offline vía [syncServiceProvider].
@riverpod
class Recording extends _$Recording {
  Timer? _timer;
  String? _audioPath;

  @override
  RecordingState build() {
    ref.onDispose(() => _timer?.cancel());
    checkConnectivity();
    cargarProyectos();
    return const RecordingState();
  }

  Stream<Amplitude>? get amplitudeStream =>
      ref.read(audioRecorderServiceProvider).onAmplitudeChanged;

  /// Verifica conexión real (ping al back-end) y actualiza el estado.
  Future<void> checkConnectivity() async {
    final online = await ref.read(connectivityServiceProvider).isOnline();
    state = state.copyWith(online: online);
  }

  /// Carga los proyectos del usuario (para elegir a cuál asociar el audio).
  Future<void> cargarProyectos() async {
    state = state.copyWith(loadingProyectos: true);
    try {
      final proyectos = await ref.read(obtenerProyectosUseCaseProvider)();
      state = state.copyWith(
        proyectos: proyectos,
        selectedProyecto: state.selectedProyecto ??
            (proyectos.isNotEmpty ? proyectos.first : null),
        loadingProyectos: false,
      );
    } catch (_) {
      // Sin proyectos disponibles: el usuario podrá crear uno.
      state = state.copyWith(loadingProyectos: false);
    }
  }

  void selectProyecto(ProyectoEntity? proyecto) =>
      state = state.copyWith(selectedProyecto: proyecto);

  Future<void> startRecording() async {
    final recorder = ref.read(audioRecorderServiceProvider);
    final allowed = await recorder.hasPermission();
    if (!allowed) {
      state = state.copyWith(
        status: RecordStatus.error,
        errorMessage: 'Necesitamos permiso de micrófono para grabar.',
      );
      return;
    }

    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);

    await recorder.start();
    state = state.copyWith(
      status: RecordStatus.recording,
      elapsed: Duration.zero,
      errorMessage: null,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state =
          state.copyWith(elapsed: state.elapsed + const Duration(seconds: 1));
    });
  }

  Future<void> stopRecording() async {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);

    _timer?.cancel();
    _audioPath = await ref.read(audioRecorderServiceProvider).stop();
    state = state.copyWith(
      status: _audioPath != null ? RecordStatus.recorded : RecordStatus.idle,
    );
  }

  /// Sube el audio grabado. Invoca [onUploaded] con el id de la grabación
  /// (estado "procesando") para pasar a la pantalla de procesamiento.
  Future<void> upload(
      {required void Function(int grabacionId) onUploaded}) async {
    if (_audioPath == null) return;
    final proyecto = state.selectedProyecto;
    if (proyecto == null) {
      state = state.copyWith(
        status: RecordStatus.error,
        errorMessage: 'Elige un proyecto antes de subir la grabación.',
      );
      return;
    }
    state = state.copyWith(
      status: RecordStatus.uploading,
      errorMessage: null,
      uploadProgress: 0.0,
    );
    try {
      if (state.isOffline) {
        final localId = DateTime.now().millisecondsSinceEpoch.toString();
        await ref.read(syncServiceProvider).queueAudio(
              localId: localId,
              audioPath: _audioPath!,
              proyectoId: proyecto.id,
              fechaGrabacion: DateTime.now().toIso8601String(),
              duracionSegundos: state.elapsed.inSeconds,
            );
        onUploaded(-1);
      } else {
        final grabacion = await ref.read(subirGrabacionUseCaseProvider)(
          audioPath: _audioPath!,
          duracionSegundos: state.elapsed.inSeconds,
          proyectoId: proyecto.id,
          onProgress: (progress) {
            state = state.copyWith(uploadProgress: progress);
          },
        );
        onUploaded(grabacion.id);
      }
    } catch (e) {
      state = state.copyWith(
        status: RecordStatus.error,
        errorMessage:
            e is ApiException ? e.message : 'No se pudo subir la grabación.',
      );
      // Si fue error de red, refresca el estado de conexión del chip.
      if (e is ApiException && e.isNetwork) checkConnectivity();
    }
  }

  Future<void> retry() async {
    _timer?.cancel();
    await ref.read(audioRecorderServiceProvider).cancel();
    _audioPath = null;
    state = state.copyWith(
      status: RecordStatus.idle,
      elapsed: Duration.zero,
      errorMessage: null,
    );
  }
}
