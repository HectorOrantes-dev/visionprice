import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/home_provider.dart';
import 'create_project_button.dart';
import 'dashboard_app_bar.dart';
import 'join_project_button.dart';
import 'new_budget_button.dart';
import 'offline_banner.dart';
import 'projects_sliver.dart';
import 'section_title.dart';

/// Contenido del dashboard: encabezado, CTAs y la lista de proyectos, con
/// pull-to-refresh sobre `homeProvider`.
class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardAppBar(),
                  // Banner de conectividad REAL: solo aparece si estás offline.
                  if (vm.isOffline) const OfflineBanner(),
                  const SizedBox(height: 16),
                  const SectionTitle('MIS PROYECTOS'),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            ProjectsSliver(state: vm, notifier: notifier),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const NewBudgetButton(),
                  const SizedBox(height: 12),
                  CreateProjectButton(notifier: notifier),
                  const SizedBox(height: 12),
                  const JoinProjectButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
