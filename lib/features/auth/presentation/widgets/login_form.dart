import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/field_label.dart';
import '../providers/login_provider.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('CORREO'),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: vm.onEmailChanged,
          decoration: InputDecoration(
            hintText: 'tu@correo.mx',
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
            errorText: vm.emailError,
          ),
        ),
        const SizedBox(height: 20),
        const FieldLabel('CONTRASEÑA'),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: vm.obscurePassword,
          onChanged: vm.onPasswordChanged,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: TextButton(
              onPressed: vm.toggleObscurePassword,
              child: Text(
                vm.obscurePassword ? 'MOSTRAR' : 'OCULTAR',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            errorText: vm.passwordError,
          ),
        ),
      ],
    );
  }
}
