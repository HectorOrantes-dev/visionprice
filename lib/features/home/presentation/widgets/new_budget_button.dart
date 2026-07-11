import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../recording/presentation/screens/recording_screen.dart';

/// Botón principal "Nuevo presupuesto por voz" → abre la grabación.
/// Antes la función privada `_newBudgetButton`.
class NewBudgetButton extends StatelessWidget {
  const NewBudgetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecordingScreen()),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            shadowColor: context.colors.primary.withValues(alpha: 0.4),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mic_rounded, size: 22, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Nuevo presupuesto por voz',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
