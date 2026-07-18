import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/location_service_provider.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../domain/entities/producto_entity.dart';
import '../providers/budget_providers.dart';
import 'material_image.dart';

/// Lista de productos de una categoría con selección por radio + botón
/// "Confirmar material" — se usa como cuerpo de la pantalla simple y también
/// empujada como sub-pantalla para elegir cada complemento del kit.
///
/// Antes el privado `_ProductoPicker`.
class ProductoPicker extends ConsumerStatefulWidget {
  final String categoria;
  final ProductoEntity? seleccionado;
  final ValueChanged<ProductoEntity> onConfirm;
  const ProductoPicker({
    super.key,
    required this.categoria,
    required this.seleccionado,
    required this.onConfirm,
  });

  @override
  ConsumerState<ProductoPicker> createState() => _ProductoPickerState();
}

class _ProductoPickerState extends ConsumerState<ProductoPicker> {
  bool _loading = true;
  String? _error;
  List<ProductoEntity> _productos = const [];
  ProductoEntity? _elegido;

  @override
  void initState() {
    super.initState();
    _elegido = widget.seleccionado;
    Future.microtask(_cargar);
  }

  Future<void> _cargar() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final location = ref.read(locationServiceProvider);
      final ubic = await location.current() ?? LocationService.fallback;
      final productos = await ref.read(obtenerProductosUseCaseProvider)(
        lat: ubic.lat,
        lng: ubic.lng,
        categoria: widget.categoria,
      );
      if (!mounted) return;
      setState(() {
        _productos = productos;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No se pudieron cargar los productos cercanos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: context.colors.textSecondary)),
        ),
      );
    }
    if (_productos.isEmpty) {
      return Center(
        child: Text('No hay productos de "${widget.categoria}" cerca de ti.',
            style: TextStyle(color: context.colors.textSecondary)),
      );
    }
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            itemCount: _productos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final p = _productos[i];
              final selected = _elegido?.productoId == p.productoId;
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _elegido = p),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? context.colors.primary : context.colors.border,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      MaterialImage(url: p.imageUrl, size: 52, radius: 12),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.heading(
                                    size: 14, weight: FontWeight.w700, color: context.colors.textPrimary)),
                            const SizedBox(height: 3),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\$${p.precioUnitario.toStringAsFixed(0)} ',
                                    style: AppTextStyles.heading(
                                        size: 16, weight: FontWeight.w800, color: context.colors.primary),
                                  ),
                                  TextSpan(
                                    text: '/ ${p.unidad}',
                                    style: TextStyle(fontSize: 12, color: context.colors.textHint),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              [
                                if (p.proveedorNombre != null) p.proveedorNombre!,
                                if (p.distanciaKm != null) '${p.distanciaKm!.toStringAsFixed(1)} km',
                              ].join(' · '),
                              style: TextStyle(fontSize: 12, color: context.colors.textHint),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        selected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: selected ? context.colors.primary : context.colors.border,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: GradientButton(
            height: 52,
            onPressed: _elegido == null ? null : () => widget.onConfirm(_elegido!),
            child: const Text('Confirmar material'),
          ),
        ),
      ],
    );
  }
}
