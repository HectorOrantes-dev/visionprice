import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Enlace al Aviso de Privacidad mostrado al pie de la vista de login.
class LoginPrivacyNotice extends StatelessWidget {
  final VoidCallback onTap;
  const LoginPrivacyNotice({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Al continuar, aceptas nuestro ',
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: onTap,
                child: const Text(
                  'Aviso de Privacidad',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
