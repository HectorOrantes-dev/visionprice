import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Estado vacío de "Mis Cotizaciones": el usuario aún no ha creado cotizaciones.
class MisPdfsEmpty extends StatelessWidget {
  const MisPdfsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_open_outlined, size: 56, color: c.textHint),
            const SizedBox(height: 12),
            Text(
              'Aún no tienes cotizaciones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Cuando generes presupuestos en tus obras, sus PDFs aparecerán aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: c.textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
