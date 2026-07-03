import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/field_label.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../domain/entities/role_entity.dart';
import '../providers/register_provider.dart';

/// Componentes de presentación del registro. Mismo lenguaje visual que el
/// login; la página (`screens/register_screen.dart`) solo los orquesta.

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Crear cuenta',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Regístrate para empezar a gestionar tus\nproyectos y presupuestos.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;

  const RegisterForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('NOMBRE'),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          onChanged: vm.onNameChanged,
          decoration: InputDecoration(
            hintText: 'Tu nombre completo',
            prefixIcon: const Icon(
              Icons.badge_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
            errorText: vm.nombreError,
          ),
        ),
        const SizedBox(height: 20),
        const FieldLabel('CORREO'),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: vm.onEmailChanged,
          decoration: InputDecoration(
            hintText: 'tu@correo.mx',
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
            errorText: vm.emailError,
          ),
        ),
        const SizedBox(height: 20),
        const FieldLabel('CONTRASEÑA'),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: vm.obscurePassword,
          onChanged: vm.onPasswordChanged,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
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
        const SizedBox(height: 20),
        const FieldLabel('TELÉFONO (OPCIONAL)'),
        const SizedBox(height: 8),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: '+52 55 1234 5678',
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const FieldLabel('ROL'),
        const SizedBox(height: 8),
        const _RoleDropdown(),
      ],
    );
  }
}

class _RoleDropdown extends StatelessWidget {
  const _RoleDropdown();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    return DropdownButtonFormField<RoleEntity>(
      value: vm.selectedRole,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Selecciona tu rol',
        prefixIcon: const Icon(
          Icons.work_outline,
          color: AppColors.textSecondary,
          size: 20,
        ),
        errorText: vm.roleError,
      ),
      items: vm.roles
          .map(
            (role) => DropdownMenuItem<RoleEntity>(
              value: role,
              child: Text(role.label),
            ),
          )
          .toList(),
      onChanged: vm.isLoading ? null : vm.selectRole,
    );
  }
}

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

/// Banner de error con el mensaje del back-end (incluye errores 422).
class RegisterErrorBanner extends StatelessWidget {
  const RegisterErrorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    if (vm.state != RegisterState.error || vm.errorMessage == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              vm.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// "¿Ya tienes cuenta? Inicia sesión" → vuelve al login.
class RegisterLoginRow extends StatelessWidget {
  final VoidCallback onTap;
  const RegisterLoginRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Ya tienes cuenta? ',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Inicia sesión',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
