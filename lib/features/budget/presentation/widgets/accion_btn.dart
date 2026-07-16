import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Botón de acción a la derecha (Recalcular / Calcular pared) con spinner.
class AccionBtn extends StatelessWidget {
  final bool loading;
  final String labelIdle;
  final String labelBusy;
  final IconData icon;
  final VoidCallback onPressed;
  const AccionBtn({
    super.key,
    required this.loading,
    required this.labelIdle,
    required this.labelBusy,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, size: 18),
        label: Text(loading ? labelBusy : labelIdle),
        style: TextButton.styleFrom(
          foregroundColor: context.colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
