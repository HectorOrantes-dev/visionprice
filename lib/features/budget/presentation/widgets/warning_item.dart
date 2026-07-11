import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Fila de una advertencia del análisis. Antes el privado `_WarningItem`.
class WarningItem extends StatelessWidget {
  final String text;
  const WarningItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: context.colors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 13, color: context.colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
