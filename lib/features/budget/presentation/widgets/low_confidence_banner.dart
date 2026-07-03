import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Aviso de baja confianza del análisis. Antes el privado `_LowConfidenceBanner`.
class LowConfidenceBanner extends StatelessWidget {
  final double? confianza;
  const LowConfidenceBanner({super.key, this.confianza});

  @override
  Widget build(BuildContext context) {
    final pct = confianza != null ? '${(confianza! * 100).round()}%' : '';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_outlined,
              size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Confianza $pct — revisa las cantidades antes de continuar',
              style: const TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
