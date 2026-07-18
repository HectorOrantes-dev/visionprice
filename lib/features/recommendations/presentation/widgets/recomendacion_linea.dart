import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Un dato de la recomendación: "etiqueta: valor" en una línea.
class RecomendacionLinea extends StatelessWidget {
  final String label;
  final String valor;
  const RecomendacionLinea({
    super.key,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(fontSize: 12, color: c.textSecondary),
            ),
            TextSpan(
              text: valor,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
