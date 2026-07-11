import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/login_provider.dart';

class LoginKeepSessionRow extends ConsumerWidget {
  final VoidCallback onForgot;
  const LoginKeepSessionRow({super.key, required this.onForgot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keepSession = ref.watch(loginProvider).keepSession;
    return Row(
      children: [
        Checkbox(
          value: keepSession,
          onChanged: (_) => ref.read(loginProvider.notifier).toggleKeepSession(),
        ),
        const SizedBox(width: 4),
        Text(
          'Mantener sesión',
          style: TextStyle(fontSize: 14, color: context.colors.textPrimary),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onForgot,
          child: Text(
            '¿Olvidaste?',
            style: TextStyle(
              fontSize: 14,
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
