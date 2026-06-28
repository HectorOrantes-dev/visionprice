import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Slider de contingencia con indicador de riesgo visual
/// Rango: 5% a 20%
class ContingencySlider extends StatelessWidget {
  const ContingencySlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 5.0,
    this.max = 20.0,
    this.divisions = 15,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;

  Color get _trackColor {
    if (value <= 8) return AppColors.success;
    if (value <= 14) return AppColors.warning;
    return AppColors.error;
  }

  String get _riskLabel {
    if (value <= 8) return 'Riesgo bajo';
    if (value <= 14) return 'Riesgo medio';
    return 'Riesgo alto';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Contingencia',
              style: AppTypography.textTheme.bodyMedium,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _trackColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: _trackColor.withOpacity(0.3), width: 0.5),
                  ),
                  child: Text(
                    _riskLabel,
                    style: AppTypography.textTheme.labelSmall
                        ?.copyWith(color: _trackColor),
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: AppTypography.textTheme.titleLarge!.copyWith(
                    color: _trackColor,
                    fontWeight: FontWeight.w700,
                  ),
                  child: Text('${value.toStringAsFixed(0)}%'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _trackColor,
            thumbColor: _trackColor,
            overlayColor: _trackColor.withOpacity(0.15),
            inactiveTrackColor: AppColors.border,
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        // Marcadores de escala
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${min.toInt()}%',
                style: AppTypography.textTheme.bodySmall,
              ),
              Text(
                '${((min + max) / 2).toInt()}%',
                style: AppTypography.textTheme.bodySmall,
              ),
              Text(
                '${max.toInt()}%',
                style: AppTypography.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Slider de desperdicio por línea de material (0% a 30%)
class WastePercentSlider extends StatelessWidget {
  const WastePercentSlider({
    super.key,
    required this.materialName,
    required this.value,
    required this.onChanged,
  });

  final String materialName;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                materialName,
                style: AppTypography.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${value.toStringAsFixed(0)}% desperdicio',
                style: AppTypography.textTheme.labelSmall
                    ?.copyWith(color: AppColors.warning),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 30,
          divisions: 30,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Botón de exportar a PDF con estado de carga animado
class ExportPdfButton extends StatelessWidget {
  const ExportPdfButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
    this.isExported = false,
  });

  final VoidCallback onTap;
  final bool isLoading;
  final bool isExported;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: isExported
            ? const LinearGradient(
                colors: [AppColors.success, AppColors.primaryDark],
              )
            : AppColors.gradientPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.textOnPrimary,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isExported
                            ? Icons.check_circle_outline
                            : Icons.picture_as_pdf_outlined,
                        color: AppColors.textOnPrimary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isExported
                            ? 'PDF Generado ✓'
                            : 'Exportar a PDF',
                        style:
                            AppTypography.textTheme.labelLarge?.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
