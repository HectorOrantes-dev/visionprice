import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../recording/domain/entities/superficie_entity.dart';
import '../../domain/categoria_material.dart';
import '../../domain/entities/producto_entity.dart';
import '../providers/nearby_stores_provider.dart';
import 'budget_result_screen.dart';

class NearbyStoresScreen extends ConsumerStatefulWidget {
  final int proyectoId;
  final double? pisoM2;
  final double? paredesM2;
  final List<SuperficieEntity>? superficies;

  const NearbyStoresScreen({
    super.key,
    required this.proyectoId,
    this.pisoM2,
    this.paredesM2,
    this.superficies,
  });

  @override
  ConsumerState<NearbyStoresScreen> createState() => _NearbyStoresScreenState();
}

class _NearbyStoresScreenState extends ConsumerState<NearbyStoresScreen> {
  @override
  void initState() {
    super.initState();
    // Carga inicial una sola vez (el provider vive mientras esta pantalla lo
    // observe). Microtask para no mutar el provider durante el primer build.
    Future.microtask(() => ref.read(nearbyStoresProvider.notifier).load(
          proyectoId: widget.proyectoId,
          pisoM2: widget.pisoM2,
          paredesM2: widget.paredesM2,
          superficies: widget.superficies,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(nearbyStoresProvider);
    final notifier = ref.read(nearbyStoresProvider.notifier);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _StoresAppBar(count: vm.productos.length),
            if (vm.usandoUbicacionAprox && !vm.loading)
              _ApproxLocationBanner(),
            const SizedBox(height: 8),
            Expanded(
              child: Stack(
                children: [
                  _body(context, vm, notifier),
                  if (vm.showUpdatePrompt)
                    Positioned(
                      top: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: notifier.refetchLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(Icons.my_location, size: 18),
                          label: const Text(
                            'Buscar en esta zona',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!vm.loading && vm.productos.isNotEmpty)
              _GenerateBar(state: vm, notifier: notifier),
          ],
        ),
      ),
    );
  }

  Widget _body(
      BuildContext context, NearbyStoresState vm, NearbyStores notifier) {
    if (vm.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null && vm.productos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            vm.errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textSecondary),
          ),
        ),
      );
    }
    if (vm.productos.isEmpty) {
      return Center(
        child: Text('No hay productos cercanos',
            style: TextStyle(color: context.colors.textSecondary)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: vm.productos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) =>
          _ProductCard(producto: vm.productos[i], state: vm, notifier: notifier),
    );
  }
}

class _StoresAppBar extends StatelessWidget {
  final int count;
  const _StoresAppBar({required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios,
                size: 18, color: context.colors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.location_on_outlined,
                color: context.colors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Materiales cercanos',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                '$count productos · elige los adecuados',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApproxLocationBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.colors.warningLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.location_off_outlined,
              size: 16, color: context.colors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Ubicación aproximada (sin permiso) · resultados cerca del centro',
              style: TextStyle(fontSize: 12, color: context.colors.warning),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductoEntity producto;
  final NearbyStoresState state;
  final NearbyStores notifier;
  const _ProductCard({
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
                _MaterialThumb(url: producto.imageUrl!),
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
                    final label = sup.descripcion.isNotEmpty
                        ? sup.descripcion
                        : sup.tipo;
                    return _SurfaceChip(
                      label: label,
                      selected: isSel,
                      onTap: () => notifier.toggleNueva(producto.productoId, sup),
                    );
                  }).toList()
                : [
                    _SurfaceChip(
                      label: 'Piso',
                      selected:
                          state.isLegacySelected(producto.productoId, 'piso'),
                      onTap: () =>
                          notifier.toggleLegacy(producto.productoId, 'piso'),
                    ),
                    _SurfaceChip(
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

class _SurfaceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SurfaceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? context.colors.primary : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? context.colors.primary : context.colors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _GenerateBar extends StatelessWidget {
  final NearbyStoresState state;
  final NearbyStores notifier;
  const _GenerateBar({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        children: [
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: state.creating
                  ? null
                  : () => notifier.generar(
                        onCreated: (cot) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BudgetResultScreen(cotizacion: cot),
                          ),
                        ),
                      ),
              child: state.creating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text('Generar cotización (${state.seleccionados})'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Miniatura del material. Usa `cacheWidth`/`cacheHeight` para que el engine
/// decodifique la imagen ya REDIMENSIONADA (fuera del hilo de UI): así una foto
/// pesada del material no infla la memoria ni causa jank al elegir materiales.
/// (Un Isolate NO aplica aquí: `Image.network` ya decodifica off-thread.)
class _MaterialThumb extends StatelessWidget {
  final String url;
  const _MaterialThumb({required this.url});

  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cache = (_size * dpr).round(); // resolución real del dispositivo
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        cacheWidth: cache,
        cacheHeight: cache,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: _size,
            height: _size,
            color: context.colors.surfaceVariant,
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stack) => Container(
          width: _size,
          height: _size,
          color: context.colors.surfaceVariant,
          child: Icon(Icons.broken_image_outlined,
              size: 20, color: context.colors.textSecondary),
        ),
      ),
    );
  }
}
