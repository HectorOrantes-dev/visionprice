import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Pestaña para elegir entre Conekta / PayPal — solo el panel del método
/// activo se muestra debajo (evita mostrar ambos flujos de pago a la vez).
class MetodoTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MetodoTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              selected ? context.colors.primaryLight : context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? context.colors.primary : context.colors.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: selected
                ? context.colors.textPrimary
                : context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
