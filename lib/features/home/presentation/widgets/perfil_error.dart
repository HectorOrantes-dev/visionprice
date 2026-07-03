import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Estado de error de la carga del perfil, con reintento. Antes `_PerfilError`.
class PerfilError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const PerfilError({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.error),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
