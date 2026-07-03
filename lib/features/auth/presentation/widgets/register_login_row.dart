import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// "¿Ya tienes cuenta? Inicia sesión" → vuelve al login.
class RegisterLoginRow extends StatelessWidget {
  final VoidCallback onTap;
  const RegisterLoginRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Ya tienes cuenta? ',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Inicia sesión',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
