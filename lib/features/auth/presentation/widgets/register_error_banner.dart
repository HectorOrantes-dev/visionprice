import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/register_provider.dart';

/// Banner de error con el mensaje del back-end (incluye errores 422).
class RegisterErrorBanner extends StatelessWidget {
  const RegisterErrorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    if (vm.state != RegisterState.error || vm.errorMessage == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              vm.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
