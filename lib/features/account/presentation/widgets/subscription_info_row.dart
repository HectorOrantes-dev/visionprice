import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Fila etiqueta/valor dentro de una tarjeta de suscripción. Antes `_Row`.
class SubscriptionInfoRow extends StatelessWidget {
  final String label;
  final String value;
  const SubscriptionInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Flexible(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 13, color: context.colors.textSecondary)),
          ),
          const Spacer(),
          Flexible(
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
