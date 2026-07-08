import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/producto_entity.dart';
import '../providers/nearby_stores_provider.dart';
import 'surface_chip.dart';

/// Tarjeta de un producto/material cercano. Antes el privado `_ProductCard`.
class ProductCard extends StatelessWidget {
  final ProductoEntity producto;
  final NearbyStoresViewModel vm;
  const ProductCard({super.key, required this.producto, required this.vm});

  @override
  Widget build(BuildContext context) {
    final usaNuevo = vm.superficies != null && vm.superficies!.isNotEmpty;
    bool selected = false;
    if (usaNuevo) {
      selected = vm.superficies!.any((sup) => vm.isNuevaSelected(producto.productoId, sup));
    } else {
      selected = vm.isLegacySelected(producto.productoId, 'piso') || 
                 vm.isLegacySelected(producto.productoId, 'paredes');
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: producto.imageUrl != null &&
                          producto.imageUrl!.isNotEmpty
                      ? Image.network(
                          producto.imageUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 60,
                              height: 60,
                              color: AppColors.surfaceVariant,
                              child: const Center(
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                ),
                              ),
                            );
                          },
                          // Falló la descarga (red/cert/CORS en web): ícono roto.
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 60,
                            height: 60,
                            color: AppColors.surfaceVariant,
                            child: const Icon(Icons.broken_image_outlined,
                                color: AppColors.textSecondary),
                          ),
                        )
                      // Sin URL de imagen en el JSON: ícono distinto.
                      : Container(
                          width: 60,
                          height: 60,
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.image_not_supported_outlined,
                              color: AppColors.textSecondary),
                        ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            producto.nombre,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${producto.precioUnitario.toStringAsFixed(2)}/${producto.unidad}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        producto.proveedorNombre ?? producto.categoria,
                        if (producto.distanciaKm != null)
                          '${producto.distanciaKm!.toStringAsFixed(1)} km',
                      ].join(' · '),
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: usaNuevo
                ? vm.superficies!.map((sup) {
                    final isSel = vm.isNuevaSelected(producto.productoId, sup);
                    final label = sup.descripcion.isNotEmpty ? sup.descripcion : sup.tipo;
                    return SurfaceChip(
                      label: label,
                      selected: isSel,
                      onTap: () => vm.toggleNueva(producto.productoId, sup),
                    );
                  }).toList()
                : [
                    SurfaceChip(
                      label: 'Piso',
                      selected: vm.isLegacySelected(producto.productoId, 'piso'),
                      onTap: () => vm.toggleLegacy(producto.productoId, 'piso'),
                    ),
                    SurfaceChip(
                      label: 'Paredes',
                      selected: vm.isLegacySelected(producto.productoId, 'paredes'),
                      onTap: () => vm.toggleLegacy(producto.productoId, 'paredes'),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}
