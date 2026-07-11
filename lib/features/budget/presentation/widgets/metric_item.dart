import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Fila de una medida detectada (piso, paredes, dimensiones). Antes `_MetricItem`.
class MetricItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final bool highlight;

  const MetricItem({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: context.colors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          Text(
            detail,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: highlight ? context.colors.primary : context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
