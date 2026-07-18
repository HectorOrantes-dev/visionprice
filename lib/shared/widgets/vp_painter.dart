import 'package:flutter/material.dart';

/// Dibuja el monograma "VP" estilizado: una V trazada y una P contigua,
/// con un brillo superior sutil para dar profundidad. Antes el privado
/// `_VpPainter`.
class VpPainter extends CustomPainter {
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
