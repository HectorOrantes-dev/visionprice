import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/recording_provider.dart';
import '../widgets/connectivity_chip.dart';
import '../widgets/mic_button.dart';
import '../widgets/project_selector.dart';
import '../widgets/recording_app_bar.dart';
import '../widgets/recording_bottom_actions.dart';
import '../widgets/recording_indicator.dart';
import '../widgets/timer_display.dart';
import '../widgets/waveform_widget.dart';

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<RecordingViewModel>(),
      child: Consumer<RecordingViewModel>(
        builder: (context, vm, _) => Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                const RecordingAppBar(),
                ProjectSelector(vm: vm),
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
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      WaveformWidget(isRecording: vm.isRecording),
                      const SizedBox(height: 32),
                      MicButton(vm: vm),
                      const SizedBox(height: 24),
                      TimerDisplay(elapsed: vm.elapsedFormatted),
                      const SizedBox(height: 12),
                      if (vm.isRecording) const RecordingIndicator(),
                      if (vm.hasRecording)
                        const Text(
                          'Grabación lista para subir',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.success,
                          ),
                        ),
                      if (vm.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 8),
                          child: Text(
                            vm.errorMessage!,
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ),
                RecordingBottomActions(vm: vm),
                const SizedBox(height: 16),
                ConnectivityChip(vm: vm),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
