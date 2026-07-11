import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Fila etiqueta/valor de la tarjeta de perfil. Antes el privado `_InfoRow`.
class PerfilInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool showDivider;

  const PerfilInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 18, color: context.colors.textSecondary),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                    fontSize: 13, color: context.colors.textSecondary),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? context.colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: context.colors.border.withValues(alpha: 0.6)),
      ],
    );
  }
}
