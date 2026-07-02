import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/vision_price_logo.dart';
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
                      vm.codeSent
                          ? 'Ingresa el código que enviamos a tu correo y tu nueva contraseña.'
                          : 'Escribe tu correo y te enviaremos un código para restablecerla.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (!vm.codeSent) ...[
                      const FieldLabel('CORREO'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
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
                        onPressed: () =>
                            vm.enviarCodigo(correo: _emailController.text),
                      ),
                    ] else ...[
                      const FieldLabel('CÓDIGO'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Código de verificación',
                          prefixIcon: const Icon(Icons.shield_outlined,
                              color: AppColors.textSecondary, size: 20),
                          errorText: vm.codeError,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const FieldLabel('NUEVA CONTRASEÑA'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
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
                          code: _codeController.text,
                          nuevaContrasena: _passwordController.text,
                          onSuccess: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Contraseña actualizada. Inicia sesión.'),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
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
