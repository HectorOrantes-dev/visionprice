import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import 'budget_section_label.dart';

/// Tarjeta "Lo que dijiste" en la revisión de parámetros. Antes el privado
/// `_TranscriptionCard` de esta pantalla.
class ReviewTranscriptionCard extends StatelessWidget {
  final String texto;
  const ReviewTranscriptionCard({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BudgetSectionLabel('LO QUE DIJISTE'),
          const SizedBox(height: 10),
          Text(
            '"$texto"',
            style: TextStyle(
              fontSize: 14,
              color: context.colors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
