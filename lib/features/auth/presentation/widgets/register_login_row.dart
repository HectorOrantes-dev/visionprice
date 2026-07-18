import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// "¿Ya tienes cuenta? Inicia sesión" → vuelve al login.
class RegisterLoginRow extends StatelessWidget {
  final VoidCallback onTap;
  const RegisterLoginRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes cuenta? ',
          style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Inicia sesión',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
