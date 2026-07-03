import 'package:flutter/material.dart';

import '../providers/nearby_stores_provider.dart';
import '../screens/budget_result_screen.dart';

/// Barra inferior para generar la cotización. Antes el privado `_GenerateBar`.
class GenerateBar extends StatelessWidget {
  final NearbyStoresViewModel vm;
  const GenerateBar({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        children: [
          if (vm.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                vm.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: vm.creating
                  ? null
                  : () => vm.generar(
                        onCreated: (cot) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BudgetResultScreen(cotizacion: cot),
                          ),
                        ),
                      ),
              child: vm.creating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text('Generar cotización (${vm.seleccionados})'),
            ),
          ),
        ],
      ),
    );
  }
}
