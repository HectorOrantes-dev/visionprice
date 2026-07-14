import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../../core/pdf/cotizacion_pdf.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../widgets/mano_obra_card.dart';
import 'budget_result_screen.dart';

/// 05 · Cotización lista — pantalla final del wizard: total general (suma
/// de todas las cotizaciones creadas, puede ser 1 o 2 si hubo mezcla
/// simple+kit), desglose combinado de líneas y descarga del PDF.
class CotizacionListaScreen extends StatelessWidget {
  final List<CotizacionEntity> cotizaciones;
  const CotizacionListaScreen({super.key, required this.cotizaciones});

  double get _total => cotizaciones.fold(0, (acc, c) => acc + c.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [context.colors.success, context.colors.success.withValues(alpha: 0.8)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.success.withValues(alpha: 0.3),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text('¡Cotización lista!',
                        style: AppTextStyles.heading(size: 24, color: context.colors.textPrimary)),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [context.colors.gradientStart, context.colors.gradientEnd],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.gradientStart.withValues(alpha: 0.3),
                          blurRadius: 32,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text('TOTAL GENERAL',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: Colors.white.withValues(alpha: 0.75))),
                        const SizedBox(height: 8),
                        Text('\$${_total.toStringAsFixed(2)}',
                            style: AppTextStyles.heading(size: 34, color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  for (final cot in cotizaciones)
                    if (cot.manoObra != null) ...[
                      ManoObraCard(
                        manoObra: cot.manoObra,
                        money: NumberFormat.currency(
                            locale: 'es_MX', symbol: '\$'),
                      ),
                      const SizedBox(height: 12),
                    ],
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Column(
                      children: [
                        for (final cot in cotizaciones)
                          for (var i = 0; i < cot.lineas.length; i++)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: (cot == cotizaciones.last && i == cot.lineas.length - 1)
                                      ? BorderSide.none
                                      : BorderSide(color: context.colors.divider),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      cot.lineas[i].descripcion,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 13, fontWeight: FontWeight.w600, color: context.colors.textPrimary),
                                    ),
                                  ),
                                  Text('\$${cot.lineas[i].subtotal.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 13, color: context.colors.textSecondary)),
                                ],
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => _verDetalle(context),
                        child: const Text('Ver detalle'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: GradientButton(
                      height: 52,
                      onPressed: () => _descargarPdf(context),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Descargar PDF'),
                        ],
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

  void _verDetalle(BuildContext context) {
    if (cotizaciones.length == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BudgetResultScreen(cotizacion: cotizaciones.first)),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Elige una cotización',
                  style: AppTextStyles.heading(size: 16, color: context.colors.textPrimary)),
            ),
            const SizedBox(height: 8),
            for (final cot in cotizaciones)
              ListTile(
                title: Text('Cotización #${cot.id}'),
                subtitle: Text('${cot.lineas.length} materiales · \$${cot.total.toStringAsFixed(2)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BudgetResultScreen(cotizacion: cot)),
                  );
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _descargarPdf(BuildContext context) async {
    final bytes = await buildResumenCotizacionesPdf(cotizaciones);
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: 'presupuesto_proyecto_${cotizaciones.isNotEmpty ? cotizaciones.first.proyectoId : ''}.pdf',
    );
  }
}
