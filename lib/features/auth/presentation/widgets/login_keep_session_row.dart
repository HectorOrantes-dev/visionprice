import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/login_provider.dart';

class LoginKeepSessionRow extends StatelessWidget {
  final VoidCallback onForgot;
  const LoginKeepSessionRow({super.key, required this.onForgot});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return Row(
      children: [
        Checkbox(
          value: vm.keepSession,
          onChanged: (_) => vm.toggleKeepSession(),
        ),
        const SizedBox(width: 4),
        const Text(
          'Mantener sesión',
          style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onForgot,
          child: const Text(
            '¿Olvidaste?',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
