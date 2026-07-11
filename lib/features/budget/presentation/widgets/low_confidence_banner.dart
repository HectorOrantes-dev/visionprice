import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

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
        color: context.colors.warningLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined,
              size: 16, color: context.colors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Confianza $pct — revisa las cantidades antes de continuar',
              style: TextStyle(
                color: context.colors.warning,
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
