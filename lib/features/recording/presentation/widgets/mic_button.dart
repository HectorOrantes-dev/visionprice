import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/recording_provider.dart';

/// Botón central de micrófono (grabar/detener). Antes el privado `_MicButton`.
class MicButton extends StatelessWidget {
  final RecordingViewModel vm;
  const MicButton({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: vm.isUploading
          ? null
          : () {
              if (vm.isRecording) {
                vm.stopRecording();
              } else if (!vm.hasRecording) {
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
          vm.isRecording ? Icons.stop : Icons.mic,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}
