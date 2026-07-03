import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injector.dart';
import '../providers/home_provider.dart';
import 'create_project_button.dart';
import 'home_app_bar.dart';
import 'home_offline_banner.dart';
import 'home_section_title.dart';
import 'new_budget_button.dart';
import 'projects_sliver.dart';

/// Pestaña de Inicio (Dashboard). Resuelve su [HomeViewModel] desde getIt y
/// arma el listado de proyectos. Antes `_DashboardTab` + `_DashboardView`.
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<HomeViewModel>(),
      child: Consumer<HomeViewModel>(
        builder: (context, vm, _) => SafeArea(
          child: RefreshIndicator(
            onRefresh: vm.refresh,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeAppBar(),
                      // Banner de conectividad REAL: solo si estás offline.
                      if (vm.isOffline) const HomeOfflineBanner(),
                      const SizedBox(height: 16),
                      const NewBudgetButton(),
                      const SizedBox(height: 12),
                      CreateProjectButton(vm: vm),
                      const SizedBox(height: 24),
                      const HomeSectionTitle('MIS PROYECTOS'),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                ProjectsSliver(vm: vm),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
