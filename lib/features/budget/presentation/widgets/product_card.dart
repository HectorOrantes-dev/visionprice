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
          const SizedBox(height: 2),
          Text(
            [
              producto.proveedorNombre ?? producto.categoria,
              if (producto.distanciaKm != null)
                '${producto.distanciaKm!.toStringAsFixed(1)} km',
            ].join(' · '),
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
