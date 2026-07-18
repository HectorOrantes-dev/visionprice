import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Tarjeta de error del procesamiento. Antes el privado `_ErrorCard`.
class ProcessingErrorCard extends StatelessWidget {
  const ProcessingErrorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.errorLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.colors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'El procesamiento falló. Vuelve a intentar la grabación.',
              style: TextStyle(fontSize: 13, color: context.colors.error),
            ),
          ),
        ],
      ),
    );
  }
}
