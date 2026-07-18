import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class LoginRegisterRow extends StatelessWidget {
  final VoidCallback onTap;
  const LoginRegisterRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta? ',
          style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Crear cuenta',
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
