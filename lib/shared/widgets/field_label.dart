import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';

/// Etiqueta de campo de formulario reutilizable (mayúsculas, espaciada).
/// Compartida por las pantallas de login y registro.
class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: context.colors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
}
