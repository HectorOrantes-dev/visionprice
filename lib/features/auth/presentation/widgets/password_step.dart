import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/field_label.dart';
import '../providers/forgot_password_provider.dart';
import 'back_step_link.dart';
import 'primary_button.dart';

/// Paso 3: definición de la nueva contraseña. Antes el privado `_PasswordStep`.
class PasswordStep extends StatelessWidget {
  final TextEditingController controller;
  final ForgotPasswordState state;
  final ForgotPassword notifier;
  final VoidCallback onSuccess;

  const PasswordStep({
    super.key,
    required this.controller,
    required this.state,
    required this.notifier,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('NUEVA CONTRASEÑA'),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: state.obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: Icon(Icons.lock_outline,
                color: context.colors.textSecondary, size: 20),
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
        const SizedBox(height: 24),
        PrimaryButton(
          loading: state.isLoading,
          label: 'Restablecer contraseña',
          onPressed: () => notifier.restablecer(
            nuevaContrasena: controller.text,
            onSuccess: onSuccess,
          ),
        ),
        const SizedBox(height: 8),
        BackStepLink(label: 'Volver al código', onTap: notifier.volverAtras),
      ],
    );
  }
}
