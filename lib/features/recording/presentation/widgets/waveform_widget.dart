import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Onda decorativa que reacciona a si se está grabando. Antes `_WaveformWidget`.
class WaveformWidget extends StatelessWidget {
  final bool isRecording;
  const WaveformWidget({super.key, required this.isRecording});

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
              color: isRecording ? context.colors.primary : context.colors.textHint,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
