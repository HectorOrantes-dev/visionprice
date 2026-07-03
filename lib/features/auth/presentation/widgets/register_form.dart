import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/field_label.dart';
import '../providers/register_provider.dart';
import 'role_dropdown.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;

  const RegisterForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('NOMBRE'),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          onChanged: vm.onNameChanged,
          decoration: InputDecoration(
            hintText: 'Tu nombre completo',
            prefixIcon: const Icon(
              Icons.badge_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
            errorText: vm.nombreError,
          ),
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
        const FieldLabel('TELÉFONO (OPCIONAL)'),
        const SizedBox(height: 8),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: '+52 55 1234 5678',
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const FieldLabel('ROL'),
        const SizedBox(height: 8),
        const RoleDropdown(),
      ],
    );
  }
}
