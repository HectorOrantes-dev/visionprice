import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

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
            icon: Icon(Icons.arrow_back_ios,
                size: 18, color: context.colors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Icon(Icons.settings, color: context.colors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Procesando',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
