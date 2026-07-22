import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../services/google_sign_in_service.dart';
import '../providers/login_provider.dart';
import '../providers/register_provider.dart';
import 'social_button.dart';

/// "Registrarte con Google": usa el rol YA seleccionado en el dropdown de
/// arriba (mismo formulario de registro) — Google no manda rol, así que es
/// el único dato que le hace falta a `POST /auth/google/register`.
///
/// El back-end es idempotente: si el correo de Google ya tiene cuenta, esto
/// simplemente inicia sesión (ignora el rol) — por eso este mismo botón sirve
/// tanto para crear cuenta nueva como para el caso "ya existe, solo entra".
class RegisterGoogleButton extends ConsumerStatefulWidget {
  const RegisterGoogleButton({super.key});

  @override
  ConsumerState<RegisterGoogleButton> createState() =>
      _RegisterGoogleButtonState();
}

class _RegisterGoogleButtonState extends ConsumerState<RegisterGoogleButton> {
  bool _cargando = false;

  Future<void> _registrarConGoogle() async {
    final rol = ref.read(registerProvider).selectedRole;
    if (rol == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un rol antes de continuar.')),
      );
      return;
    }

    setState(() => _cargando = true);
    try {
      final idToken = await GoogleSignInService.signIn();
      if (idToken == null) {
        // Usuario cerró el selector de cuenta: no es un error.
        setState(() => _cargando = false);
        return;
      }
      if (!mounted) return;
      await ref.read(loginProvider.notifier).registerWithGoogle(
            idToken: idToken,
            rol: rol.value,
            onSuccess: () {
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Refleja el mensaje de error del login/registro con Google si lo hubo
    // (ej. "Rol inválido", cuenta desactivada, etc.).
    final loginState = ref.watch(loginProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SocialButton(
          icon: Icons.g_mobiledata,
          label: _cargando ? 'Conectando…' : 'Registrarte con Google',
          onTap: _cargando ? () {} : _registrarConGoogle,
        ),
        if (loginState.errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            loginState.errorMessage!,
            style: TextStyle(color: context.colors.error, fontSize: 13),
          ),
        ],
      ],
    );
  }
}
