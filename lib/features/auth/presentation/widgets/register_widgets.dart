import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
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
        Text(
          'Crear cuenta',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Regístrate para empezar a gestionar tus\nproyectos y presupuestos.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: context.colors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('NOMBRE'),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          onChanged: notifier.onNameChanged,
          decoration: InputDecoration(
            hintText: 'Tu nombre completo',
            prefixIcon: Icon(
              Icons.badge_outlined,
              color: context.colors.textSecondary,
              size: 20,
            ),
            errorText: state.nombreError,
          ),
        ),
        const SizedBox(height: 20),
        const FieldLabel('CORREO'),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: notifier.onEmailChanged,
          decoration: InputDecoration(
            hintText: 'tu@correo.mx',
            prefixIcon: Icon(
              Icons.person_outline,
              color: context.colors.textSecondary,
              size: 20,
            ),
            errorText: state.emailError,
          ),
        ),
        const SizedBox(height: 20),
        const FieldLabel('CONTRASEÑA'),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: state.obscurePassword,
          onChanged: notifier.onPasswordChanged,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: context.colors.textSecondary,
              size: 20,
            ),
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
        const SizedBox(height: 20),
        const FieldLabel('TELÉFONO (OPCIONAL)'),
        const SizedBox(height: 8),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '+52 55 1234 5678',
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: context.colors.textSecondary,
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

class _RoleDropdown extends ConsumerWidget {
  const _RoleDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
    return DropdownButtonFormField<RoleEntity>(
      initialValue: state.selectedRole,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Selecciona tu rol',
        prefixIcon: Icon(
          Icons.work_outline,
          color: context.colors.textSecondary,
          size: 20,
        ),
        errorText: state.roleError,
      ),
      items: state.roles
          .map(
            (role) => DropdownMenuItem<RoleEntity>(
              value: role,
              child: Text(role.label),
            ),
          )
          .toList(),
      onChanged: state.isLoading ? null : notifier.selectRole,
    );
  }
}

class RegisterButton extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    if (state.requiresTwoFactor) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: state.isLoading
            ? null
            : () => ref.read(registerProvider.notifier).register(
                  nombre: nameController.text,
                  correo: emailController.text,
                  contrasena: passwordController.text,
                  telefono: phoneController.text,
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
            : const Text('Crear cuenta'),
      ),
    );
  }
}

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

/// Banner de error con el mensaje del back-end (incluye errores 422).
class RegisterErrorBanner extends ConsumerWidget {
  const RegisterErrorBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    if (state.status != RegisterStatus.error || state.errorMessage == null) {
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
              state.errorMessage!,
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
        Text(
          '¿Ya tienes cuenta? ',
          style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Inicia sesión',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
