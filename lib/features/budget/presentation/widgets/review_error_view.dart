import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Estado de error de la revisión de parámetros. Antes el privado `_ErrorView`.
class ReviewErrorView extends StatelessWidget {
  final String message;
  const ReviewErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: context.colors.error, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
