import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/register_provider.dart';

class RegisterButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;

  const RegisterButton({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    if (vm.requiresTwoFactor) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: vm.isLoading
            ? null
            : () => vm.register(
                  nombre: nameController.text,
                  correo: emailController.text,
                  contrasena: passwordController.text,
                  telefono: phoneController.text,
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
            : const Text('Crear cuenta'),
      ),
    );
  }
}
