import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Tarjeta de sección del presupuesto con header coloreado y contenido expandible
class BudgetSectionCard extends StatelessWidget {
  const BudgetSectionCard({
    super.key,
    required this.title,
    required this.totalAmount,
    required this.icon,
    required this.accentColor,
    required this.children,
    this.trailing,
    this.isExpanded = true,
  });

  final String title;
  final String totalAmount;
  final IconData icon;
  final Color accentColor;
  final List<Widget> children;
  final Widget? trailing;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border(
                bottom: BorderSide(
                  color: accentColor.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.textTheme.titleLarge,
                  ),
                ),
                Text(
                  totalAmount,
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
              ],
            ),
          ),
          // Content
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: children),
            ),
        ],
      ),
    );
  }
}
