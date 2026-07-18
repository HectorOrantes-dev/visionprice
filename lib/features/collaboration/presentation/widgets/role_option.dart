import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../models/project_role.dart';

/// Opción individual (chip) del selector de rol. Antes el privado `_RoleOption`.
class RoleOption extends StatelessWidget {
  final ProjectRole rol;
  final bool selected;
  final VoidCallback onTap;
  const RoleOption(
      {super.key, required this.rol, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = rol.color(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : context.colors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: selected ? color : context.colors.textHint,
            ),
            const SizedBox(width: 8),
            Text(
              rol.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? color : context.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
