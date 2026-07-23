import '../../../project/domain/entities/proyecto_entity.dart';

/// Estados de la pantalla de grabación:
/// - [idle] → sin grabar.
/// - [recording] → capturando audio.
/// - [recorded] → audio listo para subir.
/// - [uploading] → subiendo al back-end.
/// - [error] → ver [RecordingState.errorMessage].
enum RecordStatus { idle, recording, recorded, uploading, error }

/// Estado inmutable de la pantalla de grabación.
class RecordingState {
  final RecordStatus status;
  final Duration elapsed;
  final String? errorMessage;

  /// `error.code` del back-end cuando la subida falló (p. ej.
  /// `"plan_required"` — audio exige suscripción activa, sin cuota gratis).
  final String? errorCode;

  /// `null` mientras verifica, luego `true`/`false` según conectividad real.
  final bool? online;
  final List<ProyectoEntity> proyectos;
  final ProyectoEntity? selectedProyecto;
  final bool loadingProyectos;
  final double uploadProgress;

  const RecordingState({
    this.status = RecordStatus.idle,
    this.elapsed = Duration.zero,
    this.errorMessage,
    this.errorCode,
    this.online,
    this.proyectos = const [],
    this.selectedProyecto,
    this.loadingProyectos = false,
    this.uploadProgress = 0.0,
  });

  bool get isRecording => status == RecordStatus.recording;
  bool get isUploading => status == RecordStatus.uploading;
  bool get hasRecording => status == RecordStatus.recorded;

  /// Solo se puede subir si hay grabación Y un proyecto elegido (obligatorio).
  bool get canUpload => hasRecording && selectedProyecto != null;
  bool get isOffline => online == false;
  bool get esPagoRequerido =>
      errorCode == 'plan_limit_reached' || errorCode == 'plan_required';

  String get elapsedFormatted {
    final m = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  static const _keep = Object();

  RecordingState copyWith({
    RecordStatus? status,
    Duration? elapsed,
    Object? errorMessage = _keep,
    Object? errorCode = _keep,
    Object? online = _keep,
    List<ProyectoEntity>? proyectos,
    Object? selectedProyecto = _keep,
    bool? loadingProyectos,
    double? uploadProgress,
  }) {
    return RecordingState(
      status: status ?? this.status,
      elapsed: elapsed ?? this.elapsed,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      errorCode: errorCode == _keep ? this.errorCode : errorCode as String?,
      online: online == _keep ? this.online : online as bool?,
      proyectos: proyectos ?? this.proyectos,
      selectedProyecto: selectedProyecto == _keep
          ? this.selectedProyecto
          : selectedProyecto as ProyectoEntity?,
      loadingProyectos: loadingProyectos ?? this.loadingProyectos,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}
