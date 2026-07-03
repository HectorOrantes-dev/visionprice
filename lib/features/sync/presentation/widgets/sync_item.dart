import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'sync_status.dart';
import 'sync_status_badge.dart';

/// Tarjeta de un audio en la cola de sincronización. Antes `_SyncItem`.
class SyncItem extends StatelessWidget {
  final String name;
  final String duration;
  final String date;
  final String time;
  final SyncStatus status;
  final double? progress;

  const SyncItem({
    super.key,
    required this.name,
    required this.duration,
    required this.date,
    required this.time,
    required this.status,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.mic, size: 18, color: _iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$duration · $date · $time',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SyncStatusBadge(status: status, progress: progress),
              ],
            ),
            if (status == SyncStatus.uploading && progress != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.border,
                  color: AppColors.primary,
                  minHeight: 4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _iconBg {
    switch (status) {
      case SyncStatus.uploading:
        return AppColors.primaryLight;
      case SyncStatus.pending:
        return AppColors.warningLight;
      case SyncStatus.ready:
        return AppColors.successLight;
      case SyncStatus.error:
        return AppColors.errorLight;
    }
  }

  Color get _iconColor {
    switch (status) {
      case SyncStatus.uploading:
        return AppColors.primary;
      case SyncStatus.pending:
        return AppColors.warning;
      case SyncStatus.ready:
        return AppColors.success;
      case SyncStatus.error:
        return AppColors.error;
    }
  }
}
