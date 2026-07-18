import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Muestra el total en vivo de mano de obra (tarifa × área) bajo cada campo.
/// Antes el privado `_TotalManoObra`.
class TotalManoObra extends StatelessWidget {
  final double? tarifa;
  final double area;
  const TotalManoObra({super.key, required this.tarifa, required this.area});

  @override
  Widget build(BuildContext context) {
    if (tarifa == null || tarifa! <= 0) return const SizedBox.shrink();
    final total = tarifa! * area;
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        '= \$${total.toStringAsFixed(2)} por ${area.toStringAsFixed(area.truncateToDouble() == area ? 0 : 1)} m²',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
