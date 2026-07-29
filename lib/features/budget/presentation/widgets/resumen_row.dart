import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Fila etiqueta–valor del resumen de la cotización en la pantalla de exportar
/// PDF. Antes el privado `_ResumenRow`.
class ResumenRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;
  const ResumenRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: emphasize ? 15 : 14,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              color: emphasize
                  ? context.colors.textPrimary
                  : context.colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: emphasize ? 18 : 14,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
              color: emphasize
                  ? context.colors.primary
                  : context.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
