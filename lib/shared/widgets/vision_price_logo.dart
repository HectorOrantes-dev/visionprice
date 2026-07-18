import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import 'monogram.dart';

/// Logo de marca de VisionPrice: el monograma **VP** dentro de un cuadro
/// redondeado con degradado azul de marca. Se dibuja de forma nativa (sin
/// assets ni dependencias), así que escala nítido a cualquier tamaño.
///
/// Uso:
/// ```dart
/// const VisionPriceLogo();                 // solo el monograma
/// const VisionPriceLogo(showWordmark: true); // monograma + "VisionPrice"
/// ```
class VisionPriceLogo extends StatelessWidget {
  /// Lado del cuadro del monograma en píxeles lógicos.
  final double size;

  /// Si `true`, muestra el texto "VisionPrice" a la derecha.
  final bool showWordmark;

  const VisionPriceLogo({
    super.key,
    this.size = 44,
    this.showWordmark = false,
  });

  @override
  Widget build(BuildContext context) {
    final mark = Monogram(size: size);
    if (!showWordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: size * 0.28),
        Text(
          'VisionPrice',
          style: TextStyle(
            fontSize: size * 0.46,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
