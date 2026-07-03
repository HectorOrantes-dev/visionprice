import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Aviso de ubicación aproximada (sin permiso de GPS). Antes
/// el privado `_ApproxLocationBanner`.
class ApproxLocationBanner extends StatelessWidget {
  const ApproxLocationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off_outlined,
              size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Ubicación aproximada (sin permiso) · resultados cerca del centro',
              style: TextStyle(fontSize: 12, color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
