import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Chip seleccionable de superficie (Piso/Paredes o superficies detectadas) en
/// la tarjeta de producto. Antes el privado `_SurfaceChip`.
class SurfaceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const SurfaceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? context.colors.primary : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? context.colors.primary : context.colors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
