import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Un renglón de métrica del resultado del entrenamiento (etiqueta → valor).
class EntrenamientoStatRow extends StatelessWidget {
  final String label;
  final String value;

  /// Resalta el valor (se usa para `n_obras_reales`, la métrica clave).
  final bool destacar;

  const EntrenamientoStatRow({
    super.key,
    required this.label,
    required this.value,
    this.destacar = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, color: c.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontSize: destacar ? 16 : 14,
              fontWeight: destacar ? FontWeight.w800 : FontWeight.w600,
              color: destacar ? c.primary : c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
