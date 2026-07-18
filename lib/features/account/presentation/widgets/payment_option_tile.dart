import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Tarjeta seleccionable de método de pago (estilo radio) con logo/ícono,
/// título, descripción y check cuando está seleccionada.
class PaymentOptionTile extends StatelessWidget {
  final IconData logo;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const PaymentOptionTile({
    super.key,
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? context.colors.primaryLight : context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? context.colors.primary : context.colors.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio.
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? context.colors.primary : context.colors.border,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            // Logo/ícono en caja blanca.
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colors.border),
              ),
              child: Icon(logo, size: 24, color: context.colors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.colors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check_circle, color: context.colors.primary, size: 22),
            ],
          ],
        ),
      ),
    );
  }
}
