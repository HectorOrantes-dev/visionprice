import 'package:flutter/material.dart';

/// Caja de alto fijo para los estados de carga / error / vacío de la sección de
/// actividad reciente, para que la tarjeta no "salte" de tamaño entre estados.
class ActivityPlaceholder extends StatelessWidget {
  final Widget child;
  const ActivityPlaceholder({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SizedBox(height: 96, child: child);
}
