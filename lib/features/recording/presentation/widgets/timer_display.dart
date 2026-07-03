import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Cronómetro grande de la grabación. Antes el privado `_TimerDisplay`.
class TimerDisplay extends StatelessWidget {
  final String elapsed;
  const TimerDisplay({super.key, required this.elapsed});

  @override
  Widget build(BuildContext context) {
    return Text(
      elapsed,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 2,
      ),
    );
  }
}
