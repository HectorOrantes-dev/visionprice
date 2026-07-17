import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../providers/entrenamiento_provider.dart';
import '../widgets/entrenamiento_error.dart';
import '../widgets/entrenamiento_result_card.dart';

/// Entrenar los modelos de recomendación (`POST /recomendaciones/entrenar`).
/// Solo el rol `ingeniero_civil` puede: el back-end responde 403 al resto.
class EntrenarModelosScreen extends ConsumerWidget {
  const EntrenarModelosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(entrenamientoProvider);
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: BackButton(color: c.textPrimary),
        title: Text('Entrenar modelos',
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Junta tus obras reales (las que tienen ubicación) con las obras '
              'sintéticas y entrena el árbol Gini y el K-NN que recomiendan el kit.',
              style: TextStyle(fontSize: 13, color: c.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            estado.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => EntrenamientoError(
                message: e is ApiException
                    ? (e.statusCode == 403
                        ? 'Solo un ingeniero civil puede entrenar los modelos.'
                        : e.message)
                    : 'No se pudo entrenar.',
              ),
              data: (r) => r == null
                  ? const SizedBox.shrink()
                  : EntrenamientoResultCard(resultado: r),
            ),
            const SizedBox(height: 20),
            GradientButton(
              height: 52,
              onPressed: estado.isLoading
                  ? null
                  : () => ref.read(entrenamientoProvider.notifier).entrenar(),
              child: Text(estado.isLoading
                  ? 'Entrenando…'
                  : (estado.value == null ? 'Entrenar' : 'Entrenar de nuevo')),
            ),
          ],
        ),
      ),
    );
  }
}

