import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Aviso discreto cuando no hay recomendación disponible (p. ej. sin ubicación).
/// No estorba el flujo de elegir el kit.
class RecomendacionAviso extends StatelessWidget {
  final String texto;
  const RecomendacionAviso({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 14, color: c.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(texto,
                style: TextStyle(fontSize: 11, color: c.textSecondary)),
          ),
        ],
      ),
    );
  }
}
