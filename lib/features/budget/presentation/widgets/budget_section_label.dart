import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Etiqueta de sección (mayúsculas, espaciada) del módulo de presupuesto.
/// Antes el privado `_SectionLabel`.
class BudgetSectionLabel extends StatelessWidget {
  final String text;
  const BudgetSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: context.colors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
}
