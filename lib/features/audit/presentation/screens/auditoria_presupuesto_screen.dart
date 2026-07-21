import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../providers/auditoria_presupuesto_provider.dart';
import '../widgets/linea_auditoria_card.dart';

/// Auditoría de precios de UN presupuesto: todas sus líneas, resaltando las
/// anómalas. Acceso exclusivo Ingeniero Civil (gateado desde donde se navega
/// aquí, ej. el detalle de una cotización).
class AuditoriaPresupuestoScreen extends ConsumerWidget {
  final int presupuestoId;
  const AuditoriaPresupuestoScreen({super.key, required this.presupuestoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = auditoriaPresupuestoProvider(presupuestoId);
    final async = ref.watch(provider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Auditoría de precios',
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
                    : 'No se pudo auditar este presupuesto.',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.error),
              ),
            ),
          ),
          data: (resultado) => RefreshIndicator(
            onRefresh: () => ref.refresh(provider.future),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${resultado.total} líneas analizadas',
                          style: TextStyle(
                              fontSize: 13, color: context.colors.textSecondary)),
                      Text(
                        resultado.anomalias == 0
                            ? 'Sin anomalías'
                            : '${resultado.anomalias} con anomalía',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: resultado.anomalias == 0
                              ? context.colors.success
                              : context.colors.error,
                        ),
                      ),
                    ],
                  ),
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
