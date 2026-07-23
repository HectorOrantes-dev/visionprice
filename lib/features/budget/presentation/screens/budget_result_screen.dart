import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../audit/presentation/screens/auditoria_presupuesto_screen.dart';
import '../../../auth/presentation/providers/perfil_provider.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../widgets/budget_section_label.dart';
import '../widgets/linea_card.dart';
import '../widgets/mano_obra_card.dart';
import '../widgets/result_app_bar.dart';
import '../widgets/total_card.dart';
import 'export_pdf_screen.dart';

class BudgetResultScreen extends ConsumerWidget {
  final CotizacionEntity cotizacion;
  const BudgetResultScreen({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final money = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
    // Auditoría de precios: exclusiva Ingeniero Civil, igual gateo que en Perfil.
    final esIngenieroCivil =
        ref.watch(perfilProvider).asData?.value.rol == 'ingeniero_civil';
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const ResultAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TotalCard(
                    total: money.format(cotizacion.total),
                    estado: cotizacion.estado,
                    lineas: cotizacion.lineas.length,
                  ),
                  if (cotizacion.manoObra != null) ...[
                    const SizedBox(height: 12),
                    ManoObraCard(manoObra: cotizacion.manoObra, money: money),
                  ],
                  const SizedBox(height: 20),
                  const BudgetSectionLabel('DESGLOSE DE MATERIALES'),
                  const SizedBox(height: 8),
                  if (cotizacion.lineas.isEmpty)
                    Text('Sin líneas',
                        style: TextStyle(color: context.colors.textSecondary))
                  else
                    ...cotizacion.lineas.map(
                      (l) => LineaCard(linea: l, money: money),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Row(
                children: [
                  if (esIngenieroCivil) ...[
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AuditoriaPresupuestoScreen(
                                presupuestoId: cotizacion.id,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.fact_check_outlined, size: 18),
                          label: const Text('Auditar precios'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    flex: esIngenieroCivil ? 1 : 2,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ExportPdfScreen(cotizacion: cotizacion),
                          ),
                        ),
                        icon:
                            const Icon(Icons.picture_as_pdf_outlined, size: 18),
                        label: const Text('Exportar PDF'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
