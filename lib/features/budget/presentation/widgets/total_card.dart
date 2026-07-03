import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Tarjeta destacada con el total estimado. Antes el privado `_TotalCard`.
class TotalCard extends StatelessWidget {
  final String total;
  final String estado;
  final int lineas;
  const TotalCard({
    super.key,
    required this.total,
    required this.estado,
    required this.lineas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.info, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TOTAL ESTIMADO',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white70,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 6),
          Text(
            total,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$lineas materiales · $estado',
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
