import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/gradient_button.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/login_provider.dart';

class LoginContinueButton extends ConsumerWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginContinueButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    // Una vez enviado el código 2FA, esta sección cede el paso a la de
    // verificación (TwoFactorSection).
    if (state.requiresTwoFactor) return const SizedBox.shrink();
    return GradientButton(
      onPressed: state.isLoading
          ? null
          : () => ref.read(loginProvider.notifier).login(
                email: emailController.text,
                password: passwordController.text,
                onSuccess: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                ),
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
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Continuar'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
    );
  }
}
