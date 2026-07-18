import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../recording/domain/entities/superficie_entity.dart';
import '../providers/nearby_stores_provider.dart';
import '../widgets/approx_location_banner.dart';
import '../widgets/generate_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/stores_app_bar.dart';

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
            StoresAppBar(count: vm.productos.length),
            if (vm.usandoUbicacionAprox && !vm.loading)
              const ApproxLocationBanner(),
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
              GenerateBar(state: vm, notifier: notifier),
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
          ProductCard(producto: vm.productos[i], state: vm, notifier: notifier),
    );
  }
}
