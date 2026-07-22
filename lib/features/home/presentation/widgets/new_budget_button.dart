import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/gradient_button.dart';
import '../../../auth/presentation/providers/perfil_provider.dart';
import '../../../auth/presentation/screens/completar_perfil_screen.dart';
import '../../../recording/presentation/screens/recording_screen.dart';

/// CTA principal del dashboard: iniciar un nuevo presupuesto por voz.
///
/// Antes de grabar valida que el perfil esté completo (el registro
/// simplificado solo pide correo+contraseña+rol; nombre real/teléfono se
/// completan aquí la primera vez que hacen falta).
class NewBudgetButton extends ConsumerWidget {
  const NewBudgetButton({super.key});

  void _irAGrabar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecordingScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GradientButton(
        height: 56,
        borderRadius: BorderRadius.circular(16),
        onPressed: () async {
          // Perfil ya cacheado la mayoría de las veces (no golpea la red).
          final perfil = await ref.read(perfilProvider.future);
          if (!context.mounted) return;
          if (perfil.telefono.trim().isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CompletarPerfilScreen(
                  perfilActual: perfil,
                  onCompletado: () {
                    Navigator.pop(context); // cierra CompletarPerfilScreen
                    _irAGrabar(context);
                  },
                ),
              ),
            );
          } else {
            _irAGrabar(context);
          }
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic_rounded, size: 22, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Nuevo presupuesto por voz',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
