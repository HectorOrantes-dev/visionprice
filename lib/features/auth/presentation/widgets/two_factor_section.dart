import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/login_provider.dart';

/// Sección visible solo tras el paso 1: campo de código 2FA + botón verificar.
class TwoFactorSection extends StatelessWidget {
  final TextEditingController codeController;
  const TwoFactorSection({super.key, required this.codeController});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    if (!vm.requiresTwoFactor) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Te enviamos un código a tu correo. Ingrésalo para continuar.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Código de verificación',
            prefixIcon: const Icon(
              Icons.shield_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
            errorText: vm.codeError,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: vm.isLoading
                ? null
                : () => vm.verifyCode(
                      code: codeController.text,
                      onSuccess: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      ),
                    ),
            child: vm.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Verificar'),
          ),
        ),
      ],
    );
  }
}
