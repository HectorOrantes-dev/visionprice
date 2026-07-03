import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class LoginRegisterRow extends StatelessWidget {
  final VoidCallback onTap;
  const LoginRegisterRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿No tienes cuenta? ',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Crear cuenta',
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
