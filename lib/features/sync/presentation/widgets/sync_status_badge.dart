import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: context.colors.primary,
          ),
        );
      case SyncStatus.pending:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: context.colors.warningLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Pendiente',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.colors.warning,
            ),
          ),
        );
      case SyncStatus.ready:
        return Row(
          children: [
            Icon(Icons.check, size: 16, color: context.colors.success),
            SizedBox(width: 4),
            Text(
              'Listo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.colors.success,
              ),
            ),
          ],
        );
      case SyncStatus.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Error',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.colors.error,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Reintentar',
                style: TextStyle(
                  fontSize: 11,
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
    }
  }
}
