import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Pestaña "Mis Obras" (placeholder). Antes el privado `_MisObrasTab`.
class MisObrasTab extends StatelessWidget {
  const MisObrasTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'Mis Obras',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
