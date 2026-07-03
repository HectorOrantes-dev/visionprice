import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/nearby_stores_provider.dart';
import '../widgets/approx_location_banner.dart';
import '../widgets/generate_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/stores_app_bar.dart';

class NearbyStoresScreen extends StatelessWidget {
  final int proyectoId;
  final double? pisoM2;
  final double? paredesM2;

  const NearbyStoresScreen({
    super.key,
    required this.proyectoId,
    this.pisoM2,
    this.paredesM2,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<NearbyStoresViewModel>()
        ..load(proyectoId: proyectoId, pisoM2: pisoM2, paredesM2: paredesM2),
      child: Consumer<NearbyStoresViewModel>(
        builder: (context, vm, _) => Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                StoresAppBar(count: vm.productos.length),
                if (vm.usandoUbicacionAprox && !vm.loading)
                  const ApproxLocationBanner(),
                const SizedBox(height: 8),
                Expanded(child: _body(context, vm)),
                if (!vm.loading && vm.productos.isNotEmpty)
                  GenerateBar(vm: vm),
              ],
            ),
          ),
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
      itemBuilder: (_, i) => ProductCard(producto: vm.productos[i], vm: vm),
    );
  }
}
