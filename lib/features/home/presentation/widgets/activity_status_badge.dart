import 'package:flutter/material.dart';

/// Píldora de estado de un item de "Actividad reciente" (Confirmada, Borrador…).
class ActivityStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;

  const ActivityStatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
