import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/field_label.dart';
import '../../../../shared/widgets/vision_price_logo.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/forgot_password_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
    return ChangeNotifierProvider(
      create: (_) => getIt<ForgotPasswordViewModel>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: const BackButton(color: AppColors.textPrimary),
        ),
        body: SafeArea(
          child: Consumer<ForgotPasswordViewModel>(
            builder: (context, vm, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const VisionPriceLogo(size: 40, showWordmark: true),
                    const SizedBox(height: 32),
                    const Text(
                      'Recupera tu contraseña',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      switch (vm.step) {
                        ForgotStep.email =>
                          'Escribe tu correo y te enviaremos un código para restablecerla.',
                        ForgotStep.code =>
                          'Ingresa el código de verificación que enviamos a tu correo.',
                        ForgotStep.password =>
                          'Código verificado. Define tu nueva contraseña.',
                      },
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    switch (vm.step) {
                      ForgotStep.email => _EmailStep(
                          controller: _emailController,
                          vm: vm,
                        ),
                      ForgotStep.code => _CodeStep(
                          controller: _codeController,
                          vm: vm,
                        ),
                      ForgotStep.password => _PasswordStep(
                          controller: _passwordController,
                          vm: vm,
                          onSuccess: () {
                            if (vm.sessionActive) {
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
                    if (vm.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                vm.errorMessage!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Paso 1: captura del correo y envío del código.
class _EmailStep extends StatelessWidget {
  final TextEditingController controller;
  final ForgotPasswordViewModel vm;

  const _EmailStep({required this.controller, required this.vm});

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
          onChanged: vm.onEmailChanged,
          decoration: InputDecoration(
            hintText: 'tu@correo.mx',
            prefixIcon: const Icon(Icons.person_outline,
                color: AppColors.textSecondary, size: 20),
            errorText: vm.emailError,
          ),
        ),
        const SizedBox(height: 24),
        _PrimaryButton(
          loading: vm.isLoading,
          label: 'Enviar código',
          onPressed: () => vm.enviarCodigo(correo: controller.text),
        ),
      ],
    );
  }
}

/// Paso 2: verificación del código recibido.
class _CodeStep extends StatelessWidget {
  final TextEditingController controller;
  final ForgotPasswordViewModel vm;

  const _CodeStep({required this.controller, required this.vm});

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
          onChanged: vm.onCodeChanged,
          decoration: InputDecoration(
            hintText: 'Código de verificación',
            prefixIcon: const Icon(Icons.shield_outlined,
                color: AppColors.textSecondary, size: 20),
            errorText: vm.codeError,
          ),
        ),
        const SizedBox(height: 24),
        _PrimaryButton(
          loading: vm.isLoading,
          label: 'Verificar código',
          onPressed: () => vm.verificarCodigo(code: controller.text),
        ),
        const SizedBox(height: 8),
        _BackStepLink(label: 'Cambiar correo', onTap: vm.volverAtras),
      ],
    );
  }
}

/// Paso 3: definición de la nueva contraseña.
class _PasswordStep extends StatelessWidget {
  final TextEditingController controller;
  final ForgotPasswordViewModel vm;
  final VoidCallback onSuccess;

  const _PasswordStep({
    required this.controller,
    required this.vm,
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
          obscureText: vm.obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline,
                color: AppColors.textSecondary, size: 20),
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
        const SizedBox(height: 24),
        _PrimaryButton(
          loading: vm.isLoading,
          label: 'Restablecer contraseña',
          onPressed: () => vm.restablecer(
            nuevaContrasena: controller.text,
            onSuccess: onSuccess,
          ),
        ),
        const SizedBox(height: 8),
        _BackStepLink(label: 'Volver al código', onTap: vm.volverAtras),
      ],
    );
  }
}
