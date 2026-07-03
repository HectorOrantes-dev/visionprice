import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/register_provider.dart';

/// Sección visible solo tras el registro: campo de código 2FA + verificar.
class RegisterTwoFactorSection extends StatelessWidget {
  final TextEditingController codeController;
  const RegisterTwoFactorSection({super.key, required this.codeController});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    if (!vm.requiresTwoFactor) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Te enviamos un código a tu correo para confirmar tu cuenta.',
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
                      onSuccess: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
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
                : const Text('Confirmar cuenta'),
          ),
        ),
      ],
    );
  }
}
