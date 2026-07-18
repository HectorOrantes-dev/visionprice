import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';

/// Botón CTA con relleno degradado (marca VisionPrice), usado en las acciones
/// principales de cada pantalla ("Continuar", "Crear cuenta", "Guardar"...).
/// Envuelve [Material] + [InkWell] en vez de [ElevatedButton] para tener
/// control total del fondo con [LinearGradient] sin pelear con
/// [ElevatedButtonTheme] (que fuerza un `backgroundColor` sólido).
class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double height;
  final BorderRadius? borderRadius;
  final List<Color>? colors;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 52,
    this.borderRadius,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final grad = colors ?? [palette.gradientStart, palette.gradientEnd];
    final radius = borderRadius ?? BorderRadius.circular(14);
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: grad,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: grad.first.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: onPressed,
            child: SizedBox(
              height: height,
              width: double.infinity,
              child: Center(
                child: DefaultTextStyle.merge(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  child: IconTheme.merge(
                    data: const IconThemeData(color: Colors.white),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
