import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../recording/domain/entities/superficie_entity.dart';
import '../../domain/entities/producto_entity.dart';
import '../providers/nearby_stores_provider.dart';
import 'budget_result_screen.dart';

class NearbyStoresScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<NearbyStoresViewModel>()
        ..load(
            proyectoId: proyectoId,
            pisoM2: pisoM2,
            paredesM2: paredesM2,
            superficies: superficies),
      child: const _NearbyStoresView(),
    );
  }
}

class _NearbyStoresView extends StatelessWidget {
  const _NearbyStoresView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NearbyStoresViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
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
                  _body(context, vm),
                  if (vm.showUpdatePrompt)
                    Positioned(
                      top: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: vm.refetchLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
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
              _GenerateBar(vm: vm),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, NearbyStoresViewModel vm) {
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
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    if (vm.productos.isEmpty) {
      return const Center(
        child: Text('No hay productos cercanos',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: vm.productos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _ProductCard(producto: vm.productos[i], vm: vm),
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
            icon: const Icon(Icons.arrow_back_ios,
                size: 18, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on_outlined,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Materiales cercanos',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${count} productos · elige los adecuados',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
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
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off_outlined,
              size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Ubicación aproximada (sin permiso) · resultados cerca del centro',
              style: TextStyle(fontSize: 12, color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductoEntity producto;
  final NearbyStoresViewModel vm;
  const _ProductCard({required this.producto, required this.vm});

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
                    return _SurfaceChip(
                      label: label,
                      selected: isSel,
                      onTap: () => vm.toggleNueva(producto.productoId, sup),
                    );
                  }).toList()
                : [
                    _SurfaceChip(
                      label: 'Piso',
                      selected: vm.isLegacySelected(producto.productoId, 'piso'),
                      onTap: () => vm.toggleLegacy(producto.productoId, 'piso'),
                    ),
                    _SurfaceChip(
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
          color: selected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _GenerateBar extends StatelessWidget {
  final NearbyStoresViewModel vm;
  const _GenerateBar({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        children: [
          if (vm.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                vm.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: vm.creating
                  ? null
                  : () => vm.generar(
                        onCreated: (cot) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BudgetResultScreen(cotizacion: cot),
                          ),
                        ),
                      ),
              child: vm.creating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text('Generar cotización (${vm.seleccionados})'),
            ),
          ),
        ],
      ),
    );
  }
}
