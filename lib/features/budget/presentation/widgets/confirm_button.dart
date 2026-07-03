import 'package:flutter/material.dart';

import '../screens/nearby_stores_screen.dart';

/// Botón "Confirmar y calcular materiales". Antes el privado `_ConfirmButton`.
class ConfirmButton extends StatelessWidget {
  final int? proyectoId;
  final double? pisoM2;
  final double? paredesM2;
  const ConfirmButton({
    super.key,
    required this.proyectoId,
    required this.pisoM2,
    required this.paredesM2,
  });

  @override
  Widget build(BuildContext context) {
    // Necesitamos el proyecto (obligatorio para crear la cotización) y al menos
    // una superficie calculada.
    final enabled = proyectoId != null && (pisoM2 != null || paredesM2 != null);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: enabled
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NearbyStoresScreen(
                        proyectoId: proyectoId!,
                        pisoM2: pisoM2,
                        paredesM2: paredesM2,
                      ),
                    ),
                  )
              : null,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward, size: 18),
              SizedBox(width: 8),
              Text('Confirmar y calcular materiales'),
            ],
          ),
        ),
      ),
    );
  }
}
