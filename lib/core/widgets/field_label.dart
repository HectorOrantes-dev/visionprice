import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Etiqueta de campo de formulario reutilizable (mayúsculas, espaciada).
/// Compartida por las pantallas de login y registro.
class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
}
