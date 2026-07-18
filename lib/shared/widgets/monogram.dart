import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import 'vp_painter.dart';

/// Cuadro redondeado con degradado de marca que contiene el monograma "VP".
/// Antes el privado `_Monogram`.
class Monogram extends StatelessWidget {
  final double size;
  const Monogram({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.27),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.colors.info, context.colors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.35),
            blurRadius: size * 0.30,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: CustomPaint(
        painter: VpPainter(),
        size: Size.square(size),
      ),
    );
  }
}
