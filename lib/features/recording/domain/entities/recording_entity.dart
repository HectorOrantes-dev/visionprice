import 'recording_status.dart';

// El enum vive en su propio archivo (SRP); se re-exporta para no romper imports.
export 'recording_status.dart';

class RecordingEntity {
  final String id;
  final String name;
  final String duration;
  final String date;
  final String time;
  final RecordingStatus status;
  final double uploadProgress;

  const RecordingEntity({
    required this.id,
    required this.name,
    required this.duration,
    required this.date,
    required this.time,
    required this.status,
    this.uploadProgress = 0,
  });
}
