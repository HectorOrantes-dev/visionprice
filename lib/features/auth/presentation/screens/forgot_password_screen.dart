import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/field_label.dart';
import '../../../../shared/widgets/vision_price_logo.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/forgot_password_provider.dart';

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
                ForgotStep.email => _EmailStep(
                    controller: _emailController,
                    state: state,
                    notifier: notifier,
                  ),
                ForgotStep.code => _CodeStep(
                    controller: _codeController,
                    state: state,
                    notifier: notifier,
                  ),
                ForgotStep.password => _PasswordStep(
                    controller: _passwordController,
                    state: state,
                    notifier: notifier,
                    onSuccess: () {
                      if (state.sessionActive) {
                        // Auto-login tras el reset: directo al Home,
                        // limpiando la pila de auth.
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Contraseña actualizada. Inicia sesión.'),
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
                          style: const TextStyle(
                              color: Colors.red, fontSize: 13),
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

class _PrimaryButton extends StatelessWidget {
  final bool loading;
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.loading,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(label),
      ),
    );
  }
}

/// Enlace de texto para retroceder al paso anterior.
class _BackStepLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _BackStepLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Paso 1: captura del correo y envío del código.
class _EmailStep extends StatelessWidget {
  final TextEditingController controller;
  final ForgotPasswordState state;
  final ForgotPassword notifier;

  const _EmailStep({
    required this.controller,
    required this.state,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('CORREO'),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          onChanged: notifier.onEmailChanged,
          decoration: InputDecoration(
            hintText: 'tu@correo.mx',
            prefixIcon: Icon(Icons.person_outline,
                color: context.colors.textSecondary, size: 20),
            errorText: state.emailError,
          ),
        ),
        const SizedBox(height: 24),
        _PrimaryButton(
          loading: state.isLoading,
          label: 'Enviar código',
          onPressed: () => notifier.enviarCodigo(correo: controller.text),
        ),
      ],
    );
  }
}

/// Paso 2: verificación del código recibido.
class _CodeStep extends StatelessWidget {
  final TextEditingController controller;
  final ForgotPasswordState state;
  final ForgotPassword notifier;

  const _CodeStep({
    required this.controller,
    required this.state,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('CÓDIGO'),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: notifier.onCodeChanged,
          decoration: InputDecoration(
            hintText: 'Código de verificación',
            prefixIcon: Icon(Icons.shield_outlined,
                color: context.colors.textSecondary, size: 20),
            errorText: state.codeError,
          ),
        ),
        const SizedBox(height: 24),
        _PrimaryButton(
          loading: state.isLoading,
          label: 'Verificar código',
          onPressed: () => notifier.verificarCodigo(code: controller.text),
        ),
        const SizedBox(height: 8),
        _BackStepLink(label: 'Cambiar correo', onTap: notifier.volverAtras),
      ],
    );
  }
}

/// Paso 3: definición de la nueva contraseña.
class _PasswordStep extends StatelessWidget {
  final TextEditingController controller;
  final ForgotPasswordState state;
  final ForgotPassword notifier;
  final VoidCallback onSuccess;

  const _PasswordStep({
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
        _PrimaryButton(
          loading: state.isLoading,
          label: 'Restablecer contraseña',
          onPressed: () => notifier.restablecer(
            nuevaContrasena: controller.text,
            onSuccess: onSuccess,
          ),
        ),
        const SizedBox(height: 8),
        _BackStepLink(label: 'Volver al código', onTap: notifier.volverAtras),
      ],
    );
  }
}
