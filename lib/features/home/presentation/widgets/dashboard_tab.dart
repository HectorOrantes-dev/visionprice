import 'package:flutter/material.dart';

import 'dashboard_view.dart';

/// Pestaña "Inicio". El estado del Dashboard vive en `homeProvider` (Riverpod):
/// carga proyectos y conectividad real al observarse.
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardView();
  }
}
