import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'step_state.dart';

/// Fila de un paso del procesamiento (transcribir, interpretar…).
/// Antes el privado `_ProcessStep`.
class ProcessStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ProcessStepState state;

  const ProcessStep({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: state == ProcessStepState.inProgress
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(icon, size: 18, color: _iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: state == ProcessStepState.waiting
                        ? AppColors.textHint
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _iconBg {
    switch (state) {
      case ProcessStepState.done:
        return AppColors.successLight;
      case ProcessStepState.inProgress:
        return AppColors.primaryLight;
      case ProcessStepState.waiting:
        return AppColors.surfaceVariant;
    }
  }

  Color get _iconColor {
    switch (state) {
      case ProcessStepState.done:
        return AppColors.success;
      case ProcessStepState.inProgress:
        return AppColors.primary;
      case ProcessStepState.waiting:
        return AppColors.textHint;
    }
  }
}
