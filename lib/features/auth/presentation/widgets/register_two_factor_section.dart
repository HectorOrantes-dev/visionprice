import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/register_provider.dart';

/// Sección visible solo tras el registro: campo de código 2FA + verificar.
class RegisterTwoFactorSection extends ConsumerWidget {
  final TextEditingController codeController;
  const RegisterTwoFactorSection({super.key, required this.codeController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    if (!state.requiresTwoFactor) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Te enviamos un código a tu correo para confirmar tu cuenta.',
          style: TextStyle(
            fontSize: 14,
            color: context.colors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Código de verificación',
            prefixIcon: Icon(
              Icons.shield_outlined,
              color: context.colors.textSecondary,
              size: 20,
            ),
            errorText: state.codeError,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () => ref.read(registerProvider.notifier).verifyCode(
                      code: codeController.text,
                      onSuccess: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
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
                : const Text('Confirmar cuenta'),
          ),
        ),
      ],
    );
  }
}
