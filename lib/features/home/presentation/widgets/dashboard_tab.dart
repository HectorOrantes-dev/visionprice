import 'package:flutter/material.dart';

import 'dashboard_view.dart';

/// Pestaña "Inicio". El estado del Dashboard vive en `homeProvider` (Riverpod):
/// carga proyectos y conectividad real al observarse.
class DashboardTab extends StatelessWidget {
  /// Cambia a la pestaña "Mis Cotizaciones" (enlace "Ver todo" de la actividad
  /// reciente). Lo provee `HomeScreen`, que es quien controla el índice.
  final VoidCallback? onVerCotizaciones;

  const DashboardTab({super.key, this.onVerCotizaciones});

  @override
  Widget build(BuildContext context) {
    return DashboardView(onVerCotizaciones: onVerCotizaciones);
  }
}
