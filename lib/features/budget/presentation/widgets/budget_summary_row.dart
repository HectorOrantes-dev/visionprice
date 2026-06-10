import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Fila de resumen en la tabla de totales del presupuesto
class BudgetSummaryRow extends StatelessWidget {
  const BudgetSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.labelColor,
    this.valueColor,
    this.showDivider = false,
  });

  final String label;
  final String value;
  final bool isTotal;
  final Color? labelColor;
  final Color? valueColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: isTotal ? 14 : 10,
            horizontal: 0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: isTotal
                      ? AppTypography.textTheme.titleMedium?.copyWith(
                          color: labelColor ?? AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        )
                      : AppTypography.textTheme.bodyMedium?.copyWith(
                          color: labelColor ?? AppColors.textSecondary,
                        ),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, t, _) {
                  return Text(
                    value,
                    style: isTotal
                        ? AppTypography.textTheme.headlineSmall?.copyWith(
                            color: valueColor ?? AppColors.primary,
                            fontWeight: FontWeight.w700,
                          )
                        : AppTypography.textTheme.bodyLarge?.copyWith(
                            color: valueColor ?? AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                  );
                },
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

/// Fila de material en la lista de materiales con indicador de proveedor
class MaterialLineRow extends StatelessWidget {
  const MaterialLineRow({
    super.key,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.subtotal,
    required this.supplierName,
    required this.isPriceFromCache,
    this.wastePercent,
  });

  final String materialName;
  final String quantity;
  final String unit;
  final String unitPrice;
  final String subtotal;
  final String supplierName;
  final bool isPriceFromCache;
  final String? wastePercent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet point
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  materialName,
                  style: AppTypography.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$quantity $unit × $unitPrice',
                      style: AppTypography.textTheme.bodySmall,
                    ),
                    if (wastePercent != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '+$wastePercent% desperdicio',
                          style: AppTypography.textTheme.labelSmall?.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _SupplierChip(
                      supplierName: supplierName,
                      isPriceFromCache: isPriceFromCache,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            subtotal,
            style: AppTypography.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip pequeño que muestra proveedor y estado en tiempo real / caché
class _SupplierChip extends StatelessWidget {
  const _SupplierChip({
    required this.supplierName,
    required this.isPriceFromCache,
  });

  final String supplierName;
  final bool isPriceFromCache;

  Color get _color {
    switch (supplierName) {
      case 'Home Depot':
        return AppColors.homeDepot;
      case 'Sodimac':
        return AppColors.sodimac;
      case 'Construrama':
        return AppColors.construrama;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: _color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _color.withOpacity(0.3), width: 0.5),
          ),
          child: Text(
            supplierName,
            style: AppTypography.textTheme.labelSmall?.copyWith(
              color: _color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: isPriceFromCache
                ? AppColors.warning.withOpacity(0.12)
                : AppColors.success.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPriceFromCache ? Icons.history : Icons.wifi,
                size: 10,
                color: isPriceFromCache
                    ? AppColors.warning
                    : AppColors.success,
              ),
              const SizedBox(width: 3),
              Text(
                isPriceFromCache ? 'Caché' : 'En vivo',
                style: AppTypography.textTheme.labelSmall?.copyWith(
                  color: isPriceFromCache
                      ? AppColors.warning
                      : AppColors.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
