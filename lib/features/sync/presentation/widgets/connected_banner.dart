import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Banner "Conexión detectada · sincronizando automáticamente". Antes el
/// privado `_ConnectedBanner`.
class ConnectedBanner extends StatelessWidget {
  const ConnectedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.colors.primaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi, size: 16, color: context.colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13),
                children: [
                  TextSpan(
                    text: 'Conexión detectada · ',
                    style: TextStyle(color: context.colors.textPrimary),
                  ),
                  TextSpan(
                    text: 'sincronizando automáticamente',
                    style: TextStyle(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
