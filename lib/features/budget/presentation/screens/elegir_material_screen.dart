import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/location_service_provider.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../domain/entities/producto_entity.dart';
import '../providers/budget_providers.dart';
import '../providers/cotizacion_wizard_provider.dart';

/// 02/03 · Elegir material — misma pantalla para "simple" (un producto) y
/// "kit" (loseta principal + método + complementos), según lo que diga la
/// regla de esa categoría (`GET /cotizaciones/materiales`).
class ElegirMaterialScreen extends ConsumerWidget {
  final int proyectoId;
  final int index;
  const ElegirMaterialScreen({super.key, required this.proyectoId, required this.index});

  static String _fmtArea(double a) => a.truncateToDouble() == a ? a.toStringAsFixed(0) : a.toStringAsFixed(1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(cotizacionWizardProvider(proyectoId));
    final notifier = ref.read(cotizacionWizardProvider(proyectoId).notifier);
    final sup = wizard.superficies[index];
    final regla = wizard.reglaDe(index);
    final titulo = 'Elegir ${sup.tipo}';
    final subtitulo = '${sup.descripcion} · ${_fmtArea(sup.areaM2)} m²';

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _MaterialHeader(titulo: titulo, subtitulo: subtitulo),
            Expanded(
              child: regla.requiereKit
                  ? _KitBody(proyectoId: proyectoId, index: index)
                  : _ProductoPicker(
                      categoria: sup.tipo,
                      seleccionado: wizard.seleccionSimple[index],
                      onConfirm: (p) {
                        notifier.seleccionarSimple(index, p);
                        Navigator.pop(context);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialHeader extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  const _MaterialHeader({required this.titulo, required this.subtitulo});

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

/// Lista de productos de una categoría con selección por radio + botón
/// "Confirmar material" — se usa como cuerpo de la pantalla simple y también
/// empujada como sub-pantalla para elegir cada complemento del kit.
class _ProductoPicker extends ConsumerStatefulWidget {
  final String categoria;
  final ProductoEntity? seleccionado;
  final ValueChanged<ProductoEntity> onConfirm;
  const _ProductoPicker({
    required this.categoria,
    required this.seleccionado,
    required this.onConfirm,
  });

  @override
  ConsumerState<_ProductoPicker> createState() => _ProductoPickerState();
}

class _ProductoPickerState extends ConsumerState<_ProductoPicker> {
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
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: context.colors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.inventory_2_outlined, color: context.colors.primary, size: 22),
                      ),
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

/// Cuerpo de la pantalla KIT: secciones para el producto principal, el
/// método de crucetas, y un selector por cada complemento de la regla.
class _KitBody extends ConsumerWidget {
  final int proyectoId;
  final int index;
  const _KitBody({required this.proyectoId, required this.index});

  static const _metodos = [
    ('interseccion', 'Intersección'),
    ('tradicional', 'Tradicional'),
    ('nivelacion', 'Nivelación'),
  ];

  static const _complementoInfo = {
    'pegazulejo': ('Pegazulejo', 'pegazulejo'),
    'adhesivo': ('Pegazulejo', 'pegazulejo'),
    'cruceta': ('Crucetas', 'cruceta'),
    'boquilla': ('Boquilla', 'boquilla'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(cotizacionWizardProvider(proyectoId));
    final notifier = ref.read(cotizacionWizardProvider(proyectoId).notifier);
    final sup = wizard.superficies[index];
    final regla = wizard.reglaDe(index);
    final kit = wizard.seleccionKit[index];

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            children: [
              _KitSection(
                titulo: 'Loseta / piso principal',
                producto: kit?.principal,
                onTap: () => _elegirComplemento(
                  context,
                  categoria: sup.tipo,
                  seleccionado: kit?.principal,
                  onConfirm: (p) => notifier.seleccionarKitPrincipal(index, p),
                ),
              ),
              const SizedBox(height: 18),
              Text('MÉTODO DE INSTALACIÓN',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textSecondary,
                      letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final (valor, label) in _metodos) ...[
                    Expanded(
                      child: _MetodoChip(
                        label: label,
                        selected: (kit?.metodo ?? 'tradicional') == valor,
                        onTap: () => notifier.seleccionarKitMetodo(index, valor),
                      ),
                    ),
                    if (valor != _metodos.last.$1) const SizedBox(width: 8),
                  ],
                ],
              ),
              for (final comp in regla.complementos) ...[
                if (_complementoInfo[comp] case (final label, final categoria)) ...[
                  const SizedBox(height: 18),
                  _KitSection(
                    titulo: label,
                    producto: switch (categoria) {
                      'pegazulejo' => kit?.adhesivo,
                      'cruceta' => kit?.cruceta,
                      'boquilla' => kit?.boquilla,
                      _ => null,
                    },
                    onTap: () => _elegirComplemento(
                      context,
                      categoria: categoria,
                      seleccionado: switch (categoria) {
                        'pegazulejo' => kit?.adhesivo,
                        'cruceta' => kit?.cruceta,
                        'boquilla' => kit?.boquilla,
                        _ => null,
                      },
                      onConfirm: (p) => switch (categoria) {
                        'pegazulejo' => notifier.seleccionarKitAdhesivo(index, p),
                        'cruceta' => notifier.seleccionarKitCruceta(index, p),
                        'boquilla' => notifier.seleccionarKitBoquilla(index, p),
                        _ => null,
                      },
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: GradientButton(
            height: 52,
            onPressed: wizard.superficieCompleta(index) ? () => Navigator.pop(context) : null,
            child: Text('Confirmar kit (${_camposListos(kit, regla)} de ${1 + regla.complementos.length})'),
          ),
        ),
      ],
    );
  }

  int _camposListos(kit, regla) {
    if (kit == null) return 0;
    var n = kit.principal != null ? 1 : 0;
    for (final comp in regla.complementos) {
      switch (comp) {
        case 'pegazulejo':
        case 'adhesivo':
          if (kit.adhesivo != null) n++;
        case 'cruceta':
          if (kit.cruceta != null) n++;
        case 'boquilla':
          if (kit.boquilla != null) n++;
      }
    }
    return n;
  }

  void _elegirComplemento(
    BuildContext context, {
    required String categoria,
    required ProductoEntity? seleccionado,
    required ValueChanged<ProductoEntity> onConfirm,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: context.colors.background,
          body: SafeArea(
            child: Column(
              children: [
                _MaterialHeader(titulo: 'Elegir $categoria', subtitulo: ''),
                Expanded(
                  child: _ProductoPicker(
                    categoria: categoria,
                    seleccionado: seleccionado,
                    onConfirm: (p) {
                      onConfirm(p);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KitSection extends StatelessWidget {
  final String titulo;
  final ProductoEntity? producto;
  final VoidCallback onTap;
  const _KitSection({required this.titulo, required this.producto, required this.onTap});

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
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.colors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.inventory_2_outlined, color: context.colors.primary, size: 18),
                      ),
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

class _MetodoChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _MetodoChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? context.colors.primary : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [BoxShadow(color: context.colors.primary.withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 6))]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? Colors.white : context.colors.textPrimary,
          ),
        ),
      ),
    );
  }
}
