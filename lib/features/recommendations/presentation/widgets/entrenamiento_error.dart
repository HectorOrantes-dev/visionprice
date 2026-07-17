import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Banner de error del entrenamiento (incluye el 403 por rol no permitido).
class EntrenamientoError extends StatelessWidget {
  final String message;
  const EntrenamientoError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.errorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: c.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: TextStyle(fontSize: 13, color: c.error, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
