import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../collaboration/presentation/screens/join_project_screen.dart';

/// Enganche de colaboración: entra a la pantalla de unirse con código.
class JoinProjectButton extends StatelessWidget {
  const JoinProjectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JoinProjectScreen()),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colors.textPrimary,
            side: BorderSide(color: context.colors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login, size: 20),
              SizedBox(width: 10),
              Text(
                'Unirme con código',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
