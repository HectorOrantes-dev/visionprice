import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Encabezado de la pantalla de elegir material: botón atrás + título y
/// subtítulo. Antes el privado `_MaterialHeader`.
class MaterialHeader extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  const MaterialHeader({super.key, required this.titulo, required this.subtitulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 14),
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
                Text(titulo, style: AppTextStyles.heading(size: 20, color: context.colors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitulo, style: TextStyle(fontSize: 13, color: context.colors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
