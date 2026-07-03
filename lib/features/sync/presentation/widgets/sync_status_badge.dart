import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'sync_status.dart';

/// Indicador visual del estado de un audio (porcentaje, "Pendiente", "Listo"
/// o "Error · Reintentar"). Antes era el privado `_StatusWidget`.
class SyncStatusBadge extends StatelessWidget {
  final SyncStatus status;
  final double? progress;

  const SyncStatusBadge({super.key, required this.status, this.progress});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SyncStatus.uploading:
        return Text(
          '${((progress ?? 0) * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        );
      case SyncStatus.pending:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warningLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Pendiente',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.warning,
            ),
          ),
        );
      case SyncStatus.ready:
        return const Row(
          children: [
            Icon(Icons.check, size: 16, color: AppColors.success),
            SizedBox(width: 4),
            Text(
              'Listo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ],
        );
      case SyncStatus.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Error',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Reintentar',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
    }
  }
}
