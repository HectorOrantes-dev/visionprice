import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

/// Envuelve TODA la app (se cuelga del `builder` de `MaterialApp`, no de
/// pantalla por pantalla) para que, en pantallas anchas (tablet/escritorio/
/// web), el contenido no se estire de borde a borde — se centra en una
/// columna de ancho cómodo de leer, como hace cualquier app/sitio responsive.
/// En celular (ancho <= [_kBreakpoint]) no cambia NADA: se ve pixel-idéntico
/// a como se veía antes de este widget.
class ResponsiveAppWrapper extends StatelessWidget {
  final Widget child;
  const ResponsiveAppWrapper({super.key, required this.child});

  static const double _kBreakpoint = 600;
  static const double _kMaxWidth = 600;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= _kBreakpoint) return child;
    return ColoredBox(
      color: context.colors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxWidth),
          child: child,
        ),
      ),
    );
  }
}
