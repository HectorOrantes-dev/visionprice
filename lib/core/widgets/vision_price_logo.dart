import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
    final mark = _Monogram(size: size);
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
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _Monogram extends StatelessWidget {
  final double size;
  const _Monogram({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.27),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.info, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: size * 0.30,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _VpPainter(),
        size: Size.square(size),
      ),
    );
  }
}

/// Dibuja el monograma "VP" estilizado: una V trazada y una P contigua,
/// con un brillo superior sutil para dar profundidad.
class _VpPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Brillo superior sutil (glossy).
    final gloss = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.18),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.55));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.55), gloss);

    final stroke = w * 0.085;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // La "V": dos trazos en diagonal formando una uve.
    final vTop = h * 0.30;
    final vBottom = h * 0.70;
    final vPath = Path()
      ..moveTo(w * 0.22, vTop)
      ..lineTo(w * 0.36, vBottom)
      ..lineTo(w * 0.50, vTop);
    canvas.drawPath(vPath, paint);

    // La "P": asta vertical + lóbulo superior.
    final pX = w * 0.60;
    final pPath = Path()..moveTo(pX, vBottom)..lineTo(pX, vTop);
    canvas.drawPath(pPath, paint);

    final lobe = Path()
      ..moveTo(pX, vTop)
      ..lineTo(w * 0.70, vTop)
      ..arcToPoint(
        Offset(w * 0.70, h * 0.50),
        radius: Radius.circular(h * 0.10),
        clockwise: true,
      )
      ..lineTo(pX, h * 0.50);
    canvas.drawPath(lobe, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
