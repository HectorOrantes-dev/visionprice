import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Encabezado de la pantalla de procesamiento. Antes `_ProcessingAppBar`.
class ProcessingAppBar extends StatelessWidget {
  final bool hasError;
  final bool isDone;
  const ProcessingAppBar({
    super.key,
    required this.hasError,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = hasError
        ? 'Ocurrió un error'
        : (isDone ? 'Análisis completado' : 'Análisis de tu descripción');
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                size: 18, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                const Icon(Icons.settings, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Procesando',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
