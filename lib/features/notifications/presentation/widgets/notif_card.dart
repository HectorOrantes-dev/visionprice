import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/notificacion_entity.dart';

/// Tarjeta de una notificación. Antes el privado `_NotifCard`.
class NotifCard extends StatelessWidget {
  final NotificacionEntity notif;
  final VoidCallback onTap;
  const NotifCard({super.key, required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final leida = notif.leida;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: leida ? context.colors.surface : context.colors.primaryLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: leida ? context.colors.border : context.colors.primary,
            width: leida ? 1 : 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: leida ? context.colors.surfaceVariant : context.colors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _iconFor(notif.tipo),
                size: 18,
                color: leida ? context.colors.textSecondary : context.colors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.titulo.isEmpty ? notif.tipo : notif.titulo,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: leida ? FontWeight.w600 : FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notif.cuerpo,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.colors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  if (notif.fechaCreacion != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      notif.fechaCreacion!,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.colors.textHint,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!leida)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 8, top: 4),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String tipo) {
    final t = tipo.toLowerCase();
    if (t.contains('venc') || t.contains('pago')) return Icons.payments_outlined;
    if (t.contains('graba') || t.contains('audio')) return Icons.mic_none;
    if (t.contains('cotiz')) return Icons.receipt_long_outlined;
    return Icons.notifications_none;
  }
}
