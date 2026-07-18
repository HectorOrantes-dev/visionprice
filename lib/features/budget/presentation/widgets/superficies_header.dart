import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Encabezado de la pantalla de superficies detectadas. Antes el privado
/// `_Header`.
class SuperficiesHeader extends StatelessWidget {
  final bool loading;
  const SuperficiesHeader({super.key, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(bottom: BorderSide(color: context.colors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 18, color: context.colors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Superficies detectadas',
                  style: AppTextStyles.heading(size: 22, color: context.colors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Revisa lo que identificamos en tu grabación.',
                  style: TextStyle(fontSize: 13, color: context.colors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
