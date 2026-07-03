import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'processing_section_label.dart';

/// Tarjeta con la transcripción del audio (o su carga). Antes `_TranscriptionCard`.
class TranscriptionCard extends StatelessWidget {
  final String? transcripcion;
  final bool loading;
  const TranscriptionCard({
    super.key,
    this.transcripcion,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProcessingSectionLabel('TRANSCRIPCIÓN DEL AUDIO'),
          const SizedBox(height: 12),
          if (loading)
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  'Esperando transcripción...',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            )
          else
            Text(
              transcripcion == null || transcripcion!.isEmpty
                  ? 'Sin transcripción'
                  : '"$transcripcion"',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}
