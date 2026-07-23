import 'package:flutter/material.dart';

/// Botón de selección de PayPal con la apariencia del botón oficial
/// (amarillo, wordmark en dos tonos de azul) — a diferencia de
/// [PaymentOptionTile] (que sí es genérica), esta es específica de marca.
class PaypalPayButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const PaypalPayButton({
    super.key,
    required this.selected,
    required this.onTap,
  });

  static const _paypalYellow = Color(0xFFFFC439);
  static const _paypalNavy = Color(0xFF003087);
  static const _paypalBlue = Color(0xFF009CDE);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          color: _paypalYellow,
          borderRadius: BorderRadius.circular(28),
          border: selected
              ? Border.all(color: _paypalNavy, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: _paypalYellow.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                ),
                children: [
                  TextSpan(text: 'Pay', style: TextStyle(color: _paypalNavy)),
                  TextSpan(text: 'Pal', style: TextStyle(color: _paypalBlue)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: _paypalNavy,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
