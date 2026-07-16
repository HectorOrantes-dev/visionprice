import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Título de sección en mayúsculas (p. ej. "MIS PROYECTOS").
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

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
