import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Encabezado de la pantalla de registro (título + subtítulo).
class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crear cuenta',
          style: AppTextStyles.heading(size: 28, color: context.colors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          'Regístrate para empezar a gestionar tus\nproyectos y presupuestos.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: context.colors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
