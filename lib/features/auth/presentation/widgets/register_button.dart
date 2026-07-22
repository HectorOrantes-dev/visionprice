import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/gradient_button.dart';
import '../providers/register_provider.dart';

/// Botón "Crear cuenta" del registro (se oculta durante el paso 2FA).
class RegisterButton extends ConsumerWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    if (state.requiresTwoFactor) return const SizedBox.shrink();
    return GradientButton(
      onPressed: state.isLoading
          ? null
          : () => ref.read(registerProvider.notifier).register(
                correo: emailController.text,
                contrasena: passwordController.text,
              ),
      child: state.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Crear cuenta'),
    );
  }
}
