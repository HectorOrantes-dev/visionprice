import 'package:flutter/material.dart';

import '../providers/nearby_stores_provider.dart';
import '../screens/budget_result_screen.dart';

/// Barra inferior con el botón "Generar cotización" y el error de creación.
/// Antes el privado `_GenerateBar`.
class GenerateBar extends StatelessWidget {
  final NearbyStoresState state;
  final NearbyStores notifier;
  const GenerateBar({super.key, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        children: [
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: state.creating
                  ? null
                  : () => notifier.generar(
                        onCreated: (cot) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BudgetResultScreen(cotizacion: cot),
                          ),
                        ),
                      ),
              child: state.creating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text('Generar cotización (${state.seleccionados})'),
            ),
          ),
        ],
      ),
    );
  }
}
