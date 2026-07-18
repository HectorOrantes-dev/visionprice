import 'package:flutter/material.dart';

import '../../../../shared/widgets/gradient_button.dart';
import '../../../recording/presentation/screens/recording_screen.dart';

/// CTA principal del dashboard: iniciar un nuevo presupuesto por voz.
class NewBudgetButton extends StatelessWidget {
  const NewBudgetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GradientButton(
        height: 56,
        borderRadius: BorderRadius.circular(16),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecordingScreen()),
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
    );
  }
}
