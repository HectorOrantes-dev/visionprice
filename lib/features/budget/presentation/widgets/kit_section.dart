import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/producto_entity.dart';
import 'material_image.dart';

/// Sección del kit: título + tarjeta que muestra el producto elegido (o el
/// placeholder "Elegir producto"). Antes el privado `_KitSection`.
class KitSection extends StatelessWidget {
  final String titulo;
  final ProductoEntity? producto;
  final VoidCallback onTap;
  const KitSection({super.key, required this.titulo, required this.producto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo.toUpperCase(),
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: context.colors.textSecondary, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: producto == null
              ? Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.colors.border, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 16, color: context.colors.primary),
                      const SizedBox(width: 6),
                      Text('Elegir producto',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700, color: context.colors.primary)),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Row(
                    children: [
                      MaterialImage(url: producto!.imageUrl, size: 40, radius: 10),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(producto!.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.heading(
                                    size: 13, weight: FontWeight.w700, color: context.colors.textPrimary)),
                            Text(
                              '\$${producto!.precioUnitario.toStringAsFixed(0)} / ${producto!.unidad}'
                              '${producto!.proveedorNombre != null ? ' · ${producto!.proveedorNombre}' : ''}',
                              style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: context.colors.textHint),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
