import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/subscription_entity.dart';
import 'subscription_info_row.dart';

/// Tarjeta de una suscripción. Antes el privado `_SubscriptionCard`.
class SubscriptionCard extends StatelessWidget {
  final SubscriptionEntity sub;
  const SubscriptionCard({super.key, required this.sub});

  @override
  Widget build(BuildContext context) {
    final color = sub.activa ? AppColors.success : AppColors.textSecondary;
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
          Row(
            children: [
              const Icon(Icons.workspace_premium_outlined,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  sub.plan,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sub.estado.isEmpty ? '—' : sub.estado,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          if (sub.precio != null || sub.vigenciaHasta != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            if (sub.precio != null)
              SubscriptionInfoRow(
                  label: 'Precio',
                  value: '\$${sub.precio!.toStringAsFixed(2)}'),
            if (sub.vigenciaHasta != null)
              SubscriptionInfoRow(
                  label: 'Vigente hasta', value: sub.vigenciaHasta!),
          ],
        ],
      ),
    );
  }
}
