import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/recording_provider.dart';
import 'audio_visualizer.dart';
import 'bottom_actions.dart';
import 'connectivity_chip.dart';
import 'mic_button.dart';
import 'project_selector.dart';
import 'recording_app_bar.dart';
import 'recording_indicator.dart';
import 'timer_display.dart';

/// Contenido de la pantalla de grabación. Antes el privado `_RecordingView`.
class RecordingView extends ConsumerWidget {
  const RecordingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingProvider);
    final notifier = ref.read(recordingProvider.notifier);

    // Look inmersivo: esta pantalla siempre se ve oscura (fondo degradado
    // navy), independientemente del ThemeMode.system del resto de la app.
    // El Theme(copyWith(extensions:[AppPalette.dark])) local hace que TODO
    // el subárbol (incluidos AudioVisualizer, chips, etc.) resuelva
    // context.colors contra la paleta oscura sin tocar app.dart.
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [AppPalette.dark],
        brightness: Brightness.dark,
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1220), Color(0xFF12213F), Color(0xFF16294A)],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                const RecordingAppBar(),
                ProjectSelector(state: state),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Describe el espacio y los trabajos a realizar,\ncomo si le explicaras a un compañero',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: context.colors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      AudioVisualizer(
                        amplitudeStream: notifier.amplitudeStream,
                        isRecording: state.isRecording,
                      ),
                      const SizedBox(height: 32),
                      MicButton(state: state, notifier: notifier),
                      const SizedBox(height: 24),
                      TimerDisplay(elapsed: state.elapsedFormatted),
                      const SizedBox(height: 12),
                      if (state.isRecording) const RecordingIndicator(),
                      if (state.hasRecording)
                        Text(
                          'Grabación lista para subir',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.colors.success,
                          ),
                        ),
                      if (state.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 8),
                          child: Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ),
                BottomActions(state: state, notifier: notifier),
                const SizedBox(height: 16),
                ConnectivityChip(state: state, notifier: notifier),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
