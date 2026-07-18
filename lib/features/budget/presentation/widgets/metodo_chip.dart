import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Chip seleccionable para el método de instalación del kit. Antes el privado
/// `_MetodoChip`.
class MetodoChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const MetodoChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? context.colors.primary : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [BoxShadow(color: context.colors.primary.withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 6))]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? Colors.white : context.colors.textPrimary,
          ),
        ),
      ),
    );
  }
}
