import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Badge "Dueño" que acompaña al nombre del propietario del proyecto. Antes el
/// privado `_OwnerBadge`.
class OwnerBadge extends StatelessWidget {
  const OwnerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Dueño',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
