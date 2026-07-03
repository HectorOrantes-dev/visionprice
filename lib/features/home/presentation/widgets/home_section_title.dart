import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Título de sección de la home (mayúsculas). Antes el privado `_SectionTitle`.
class HomeSectionTitle extends StatelessWidget {
  final String text;
  const HomeSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
