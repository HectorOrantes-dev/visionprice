import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_palette.dart';

/// Tarjeta que muestra la **mano de obra** de una cotización como dato
/// separado (el back-end la expone en el campo `mano_obra`, además de incluirla
/// como línea en el desglose/PDF). Se coloca junto al total de cada cotización.
///
/// Si la cotización no trae mano de obra ([manoObra] es `null`), no se pinta.
class ManoObraCard extends StatelessWidget {
  final double? manoObra;
  final NumberFormat money;

  const ManoObraCard({
    super.key,
    required this.manoObra,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    final value = manoObra;
    if (value == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: context.colors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.handyman_outlined,
                size: 20, color: context.colors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mano de obra',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Incluida en el total',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            money.format(value),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
