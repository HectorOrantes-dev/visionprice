import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/field_label.dart';
import '../providers/register_provider.dart';
import 'role_dropdown.dart';

/// Formulario de datos del registro: solo correo, contraseña y rol. El
/// nombre real y el teléfono se completan después (ver
/// `CompletarPerfilScreen`), para que el alta sea lo más rápida posible.
class RegisterForm extends ConsumerWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('CORREO'),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: notifier.onEmailChanged,
          decoration: InputDecoration(
            hintText: 'tu@correo.mx',
            prefixIcon: Icon(
              Icons.person_outline,
              color: context.colors.textSecondary,
              size: 20,
            ),
            errorText: state.emailError,
          ),
        ),
        const SizedBox(height: 20),
        const FieldLabel('CONTRASEÑA'),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: state.obscurePassword,
          onChanged: notifier.onPasswordChanged,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: context.colors.textSecondary,
              size: 20,
            ),
            suffixIcon: TextButton(
              onPressed: notifier.toggleObscurePassword,
              child: Text(
                state.obscurePassword ? 'MOSTRAR' : 'OCULTAR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
            errorText: state.passwordError,
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
