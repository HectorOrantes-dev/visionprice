import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
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
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _iconBg(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.mic, size: 18, color: _iconColor(context)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Text(
                        '$duration · $date · $time',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.textSecondary,
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
                  backgroundColor: context.colors.border,
                  color: context.colors.primary,
                  minHeight: 4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _iconBg(BuildContext context) {
    switch (status) {
      case SyncStatus.uploading:
        return context.colors.primaryLight;
      case SyncStatus.pending:
        return context.colors.warningLight;
      case SyncStatus.ready:
        return context.colors.successLight;
      case SyncStatus.error:
        return context.colors.errorLight;
    }
  }

  Color _iconColor(BuildContext context) {
    switch (status) {
      case SyncStatus.uploading:
        return context.colors.primary;
      case SyncStatus.pending:
        return context.colors.warning;
      case SyncStatus.ready:
        return context.colors.success;
      case SyncStatus.error:
        return context.colors.error;
    }
  }
}
