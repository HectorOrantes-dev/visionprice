import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Pestaña "Mis Obras" (placeholder). Antes el privado `_MisObrasTab`.
class MisObrasTab extends StatelessWidget {
  const MisObrasTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          'Mis Obras',
          style: TextStyle(
            fontSize: 18,
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
