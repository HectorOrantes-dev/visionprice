import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../providers/anomalias_zona_provider.dart';
import '../widgets/linea_auditoria_card.dart';

/// Escaneo de zona: solo las líneas anómalas cerca de tu ubicación actual, de
/// TODOS los presupuestos (no solo los tuyos). Acceso exclusivo Ingeniero
/// Civil.
class AnomaliasZonaScreen extends ConsumerWidget {
  const AnomaliasZonaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(anomaliasZonaProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Anomalías en tu zona',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                e is ApiException
                    ? e.message
                    : 'No se pudieron cargar las anomalías de la zona.',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.error),
              ),
            ),
          ),
          data: (resultado) => RefreshIndicator(
            onRefresh: () => ref.refresh(anomaliasZonaProvider.future),
            child: resultado.lineas.isEmpty
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            'No se detectaron precios anómalos cerca de ti.',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: context.colors.textSecondary),
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        '${resultado.total} línea(s) anómala(s) detectada(s)',
                        style: TextStyle(
                            fontSize: 13, color: context.colors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      for (final linea in resultado.lineas) ...[
                        LineaAuditoriaCard(linea: linea),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
