import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

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
          decoration: BoxDecoration(
            color: context.colors.recordingRed,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Grabando...',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.colors.recordingRed,
          ),
        ),
      ],
    );
  }
}
