import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/recording_provider.dart';
import '../../../sync/presentation/screens/processing_screen.dart';

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecordingViewModel(),
      child: const _RecordingView(),
    );
  }
}

class _RecordingView extends StatelessWidget {
  const _RecordingView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecordingViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _RecordingAppBar(),
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
                  _WaveformWidget(isRecording: vm.isRecording),
                  const SizedBox(height: 32),
                  _MicButton(vm: vm),
                  const SizedBox(height: 24),
                  _TimerDisplay(elapsed: vm.elapsedFormatted),
                  const SizedBox(height: 12),
                  if (vm.isRecording) _RecordingIndicator(),
                ],
              ),
            ),
            _BottomActions(vm: vm),
            const SizedBox(height: 16),
            _OfflineChip(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _RecordingAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                size: 18, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nueva grabación',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Funciona sin internet',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaveformWidget extends StatelessWidget {
  final bool isRecording;
  const _WaveformWidget({required this.isRecording});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(20, (i) {
          final heights = [
            12.0, 20.0, 28.0, 16.0, 36.0, 24.0, 40.0, 18.0, 32.0, 22.0,
            38.0, 14.0, 28.0, 20.0, 34.0, 16.0, 26.0, 30.0, 18.0, 12.0,
          ];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 3,
            height: heights[i],
            decoration: BoxDecoration(
              color: isRecording
                  ? AppColors.primary
                  : AppColors.textHint,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  final RecordingViewModel vm;
  const _MicButton({required this.vm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (vm.isRecording) {
          vm.stopRecording();
        } else {
          vm.startRecording();
        }
      },
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color: vm.isRecording ? AppColors.recordingRed : AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (vm.isRecording ? AppColors.recordingRed : AppColors.primary)
                  .withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final String elapsed;
  const _TimerDisplay({required this.elapsed});

  @override
  Widget build(BuildContext context) {
    return Text(
      '00:$elapsed',
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 2,
      ),
    );
  }
}

class _RecordingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.recordingRed,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Grabando...',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.recordingRed,
          ),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  final RecordingViewModel vm;
  const _BottomActions({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.recordingRed,
              ),
              onPressed: vm.isRecording
                  ? () {
                      vm.stopRecording();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProcessingScreen()),
                      );
                    }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProcessingScreen()),
                      );
                    },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stop, size: 18),
                  SizedBox(width: 8),
                  Text('Detener grabación'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: vm.retryRecording,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.replay, size: 18),
                  SizedBox(width: 8),
                  Text('Reintentar grabación'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off, size: 14, color: AppColors.warning),
          const SizedBox(width: 8),
          Text(
            'Sin internet · audio guardado localmente',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.warning,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
