import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Insignias de confianza (pago seguro / cifrado SSL) del pie de la pantalla
/// de pago.
class TrustBadges extends StatelessWidget {
  const TrustBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _badge(context, Icons.verified_user_outlined, 'Secure Payment'),
        const SizedBox(width: 24),
        _badge(context, Icons.shield_outlined, 'SSL Encrypted'),
      ],
    );
  }

  Widget _badge(BuildContext context, IconData icon, String label) {
    return Opacity(
      opacity: 0.7,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: context.colors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
