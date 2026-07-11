import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

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
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: context.colors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
