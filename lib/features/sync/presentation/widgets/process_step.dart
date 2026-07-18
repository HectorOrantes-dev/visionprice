import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _iconBg(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: state == ProcessStepState.inProgress
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: context.colors.primary,
                    ),
                  )
                : Icon(icon, size: 18, color: _iconColor(context)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: state == ProcessStepState.waiting
                        ? context.colors.textHint
                        : context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _iconBg(BuildContext context) {
    switch (state) {
      case ProcessStepState.done:
        return context.colors.successLight;
      case ProcessStepState.inProgress:
        return context.colors.primaryLight;
      case ProcessStepState.waiting:
        return context.colors.surfaceVariant;
    }
  }

  Color _iconColor(BuildContext context) {
    switch (state) {
      case ProcessStepState.done:
        return context.colors.success;
      case ProcessStepState.inProgress:
        return context.colors.primary;
      case ProcessStepState.waiting:
        return context.colors.textHint;
    }
  }
}
