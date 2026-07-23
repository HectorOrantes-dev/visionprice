import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../services/google_sign_in_service.dart';
import '../providers/login_provider.dart';
import '../screens/register_screen.dart';
import 'social_button.dart';

class SocialButtons extends ConsumerStatefulWidget {
  const SocialButtons({super.key});

  @override
  ConsumerState<SocialButtons> createState() => _SocialButtonsState();
}

class _SocialButtonsState extends ConsumerState<SocialButtons> {
  bool _cargando = false;

  Future<void> _iniciarConGoogle() async {
    setState(() => _cargando = true);
    try {
      final idToken = await GoogleSignInService.signIn();
      if (idToken == null) {
        // El usuario cerró el selector de cuenta: no es un error.
        setState(() => _cargando = false);
        return;
      }
      if (!mounted) return;
      await ref.read(loginProvider.notifier).loginWithGoogle(
            idToken: idToken,
            onSuccess: () {
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
            onNeedsRegister: () {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'No tienes cuenta con ese correo de Google — regístrate.'),
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
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
    // `loginWithGoogle` guarda cualquier falla que NO sea "usuario no
    // registrado" (404 → onNeedsRegister) en `errorMessage` sin relanzarla:
    // si nadie observa el provider aquí, un 401/402/500 deja el botón
    // reseteado a "Google" SIN ningún aviso visible (se sentía como que "se
    // quedó cargando" sin pasar a nada). Mostrarlo, igual que ya hace
    // RegisterGoogleButton en la pantalla de registro.
    final loginState = ref.watch(loginProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: SocialButton(
                icon: Icons.g_mobiledata,
                label: _cargando ? 'Conectando…' : 'Google',
                onTap: _cargando ? () {} : _iniciarConGoogle,
              ),
            ),
          ],
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
