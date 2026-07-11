import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inicia sesión',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Accede a tus proyectos y presupuestos en\ncualquier dispositivo.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: c.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
