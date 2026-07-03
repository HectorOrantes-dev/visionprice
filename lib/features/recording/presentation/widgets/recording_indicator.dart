import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Indicador "Grabando..." con punto rojo. Antes el privado `_RecordingIndicator`.
class RecordingIndicator extends StatelessWidget {
  const RecordingIndicator({super.key});

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
