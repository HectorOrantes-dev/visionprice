import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Banner "Sin conexión" de la home. Antes el privado `_OfflineBanner`.
class HomeOfflineBanner extends StatelessWidget {
  const HomeOfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warningLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, size: 18, color: AppColors.warning),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Sin conexión — los audios se guardan localmente',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
