import 'dart:async';
import 'package:flutter/material.dart';

enum RecordingState { idle, recording, stopped }

class RecordingViewModel extends ChangeNotifier {
  RecordingState _state = RecordingState.idle;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  final bool _hasInternet = false;

  RecordingState get state => _state;
  Duration get elapsed => _elapsed;
  bool get isRecording => _state == RecordingState.recording;
  bool get hasInternet => _hasInternet;

  String get elapsedFormatted {
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void startRecording() {
    _state = RecordingState.recording;
    _elapsed = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += const Duration(seconds: 1);
      notifyListeners();
    });
    notifyListeners();
  }

  void stopRecording() {
    _timer?.cancel();
    _state = RecordingState.stopped;
    notifyListeners();
  }

  void retryRecording() {
    _state = RecordingState.idle;
    _elapsed = Duration.zero;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
