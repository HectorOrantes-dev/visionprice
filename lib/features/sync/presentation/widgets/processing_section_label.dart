import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Etiqueta de sección de la pantalla de procesamiento. Antes `_SectionLabel`.
class ProcessingSectionLabel extends StatelessWidget {
  final String text;
  const ProcessingSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
}
