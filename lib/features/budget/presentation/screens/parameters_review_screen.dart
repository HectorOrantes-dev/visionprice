import 'package:flutter/material.dart';

import '../widgets/parameters_view.dart';

/// Pantalla de revisión de parámetros: muestra la transcripción, las medidas
/// detectadas y permite confirmar para calcular materiales.
class ParametersReviewScreen extends StatelessWidget {
  final int grabacionId;
  const ParametersReviewScreen({super.key, required this.grabacionId});

  @override
  Widget build(BuildContext context) {
    return ParametersView(grabacionId: grabacionId);
  }
}
