import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Estado vacío de la lista de proyectos. Antes el privado `_EmptyProjects`.
class EmptyProjects extends StatelessWidget {
  const EmptyProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Icon(Icons.folder_open_outlined,
              size: 40, color: AppColors.textHint),
          const SizedBox(height: 12),
          const Text(
            'Aún no tienes proyectos',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Crea tu primer proyecto con el botón de arriba para empezar a grabar presupuestos.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
