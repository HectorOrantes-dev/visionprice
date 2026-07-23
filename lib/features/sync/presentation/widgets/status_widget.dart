import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import 'sync_status.dart';

/// Indicador de estado (porcentaje, "Procesando", "Pendiente", "Listo",
/// "Error") de un item de la cola. Antes el privado `_StatusWidget`.
class StatusWidget extends StatelessWidget {
  final SyncStatus status;
  final double? progress;

  const StatusWidget({super.key, required this.status, this.progress});

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
      case SyncStatus.processing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.blue),
              ),
              SizedBox(width: 6),
              Text(
                'Procesando',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
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
