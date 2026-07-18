import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Enlace de texto para retroceder al paso anterior. Antes el privado
/// `_BackStepLink`.
class BackStepLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const BackStepLink({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
