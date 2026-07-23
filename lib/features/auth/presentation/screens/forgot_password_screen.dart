import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/vision_price_logo.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/forgot_password_provider.dart';
import '../widgets/code_step.dart';
import '../widgets/email_step.dart';
import '../widgets/password_step.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordProvider);
    final notifier = ref.read(forgotPasswordProvider.notifier);
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const VisionPriceLogo(size: 40, showWordmark: true),
              const SizedBox(height: 32),
              Text(
                'Recupera tu contraseña',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                switch (state.step) {
                  ForgotStep.email =>
                    'Escribe tu correo y te enviaremos un código para restablecerla.',
                  ForgotStep.code =>
                    'Ingresa el código de verificación que enviamos a tu correo.',
                  ForgotStep.password =>
                    'Código verificado. Define tu nueva contraseña.',
                },
                style: TextStyle(
                  fontSize: 15,
                  color: context.colors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              switch (state.step) {
                ForgotStep.email => EmailStep(
                    controller: _emailController,
                    state: state,
                    notifier: notifier,
                  ),
                ForgotStep.code => CodeStep(
                    controller: _codeController,
                    state: state,
                    notifier: notifier,
                  ),
                ForgotStep.password => PasswordStep(
                    controller: _passwordController,
                    state: state,
                    notifier: notifier,
                    onSuccess: () {
                      if (state.sessionActive) {
                        // Auto-login tras el reset: directo al Home,
                        // limpiando la pila de auth.
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Contraseña actualizada. Inicia sesión.'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
              },
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
