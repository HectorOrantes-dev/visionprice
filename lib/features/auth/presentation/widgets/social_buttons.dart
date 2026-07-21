import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../../services/google_sign_in_service.dart';
import '../providers/login_provider.dart';
import '../screens/google_role_screen.dart';
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GoogleRoleScreen(idToken: idToken),
                ),
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
    return Row(
      children: [
        Expanded(
          child: SocialButton(
            icon: Icons.g_mobiledata,
            label: _cargando ? 'Conectando…' : 'Google',
            onTap: _cargando ? () {} : _iniciarConGoogle,
          ),
        ),
      ],
    );
  }
}
