import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/categoria_material.dart';
import '../../domain/entities/producto_entity.dart';
import '../providers/nearby_stores_provider.dart';
import 'material_image.dart';
import 'surface_chip.dart';

/// Tarjeta de un producto cercano con sus chips de superficie asignables.
/// Antes el privado `_ProductCard`.
class ProductCard extends StatelessWidget {
  final ProductoEntity producto;
  final NearbyStoresState state;
  final NearbyStores notifier;
  const ProductCard({
    super.key,
    required this.producto,
    required this.state,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final usaNuevo = state.superficies != null && state.superficies!.isNotEmpty;
    bool selected = false;
    if (usaNuevo) {
      selected = state.superficies!
          .any((sup) => state.isNuevaSelected(producto.productoId, sup));
    } else {
      selected = state.isLegacySelected(producto.productoId, 'piso') ||
          state.isLegacySelected(producto.productoId, 'paredes');
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? context.colors.primary : context.colors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (producto.imageUrl != null &&
                  producto.imageUrl!.isNotEmpty) ...[
                MaterialImage(url: producto.imageUrl, size: 48, radius: 10),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  producto.nombre,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              Text(
                '\$${producto.precioUnitario.toStringAsFixed(2)}/${producto.unidad}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            [
              producto.proveedorNombre ?? producto.categoria,
              if (producto.distanciaKm != null)
                '${producto.distanciaKm!.toStringAsFixed(1)} km',
            ].join(' · '),
            style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: usaNuevo
                ? state.superficies!
                    // Solo ofrecemos las superficies cuyo material coincide con
                    // la categoría del producto (ej. una pintura solo se puede
                    // asignar a la superficie de "cambio de pintura").
                    .where((sup) =>
                        CategoriaMaterial.productoAplicaA(producto, sup))
                    .map((sup) {
                    final isSel =
                        state.isNuevaSelected(producto.productoId, sup);
                    final label =
                        sup.descripcion.isNotEmpty ? sup.descripcion : sup.tipo;
                    return SurfaceChip(
                      label: label,
                      selected: isSel,
                      onTap: () =>
                          notifier.toggleNueva(producto.productoId, sup),
                    );
                  }).toList()
                : [
                    SurfaceChip(
                      label: 'Piso',
                      selected:
                          state.isLegacySelected(producto.productoId, 'piso'),
                      onTap: () =>
                          notifier.toggleLegacy(producto.productoId, 'piso'),
                    ),
                    SurfaceChip(
                      label: 'Paredes',
                      selected: state.isLegacySelected(
                          producto.productoId, 'paredes'),
                      onTap: () =>
                          notifier.toggleLegacy(producto.productoId, 'paredes'),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}
