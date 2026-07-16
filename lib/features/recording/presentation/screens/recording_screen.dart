import 'package:flutter/material.dart';

import '../widgets/recording_view.dart';

/// Pantalla de grabación de audio: captura la descripción del espacio y permite
/// subirla para procesarla.
class RecordingScreen extends StatelessWidget {
  const RecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RecordingView();
  }
}
