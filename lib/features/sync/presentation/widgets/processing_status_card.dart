import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Tarjeta de estado/confianza del procesamiento. Antes `_StatusCard`.
class ProcessingStatusCard extends StatelessWidget {
  final bool isDone;
  final double? confianza;
  const ProcessingStatusCard({super.key, required this.isDone, this.confianza});

  @override
  Widget build(BuildContext context) {
    final pct = confianza != null ? '${(confianza! * 100).round()}%' : null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            isDone ? 'Estado' : 'Procesando',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            isDone
                ? (pct != null ? 'Listo · confianza $pct' : 'Sincronizado')
                : '~ unos segundos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDone ? AppColors.success : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
