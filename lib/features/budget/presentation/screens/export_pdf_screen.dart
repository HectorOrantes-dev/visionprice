import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../../../core/pdf/pdf_saver.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../providers/export_pdf_provider.dart';
import '../widgets/resumen_row.dart';

/// Exportar PDF de una cotización. El PDF se genera **localmente** en un isolate
/// (sin depender del back-end) y se **descarga directo al teléfono** (sin abrir
/// el diálogo de impresión). También se puede compartir (`Printing.sharePdf`).
class ExportPdfScreen extends ConsumerWidget {
  final CotizacionEntity cotizacion;
  const ExportPdfScreen({super.key, required this.cotizacion});

  Future<void> _descargarPdf(BuildContext context, WidgetRef ref) async {
    final bytes =
        await ref.read(exportPdfProvider.notifier).generarPdfLocal(cotizacion);
    if (bytes == null) return;
    final res = await savePdfToDevice(bytes, 'cotizacion_${cotizacion.id}.pdf');
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res.ok
            ? (res.enDescargas
                ? 'PDF guardado en Descargas: cotizacion_${cotizacion.id}.pdf'
                : 'PDF guardado en: ${res.path}')
            : 'No se pudo guardar el PDF.'),
      ),
    );
  }

  Future<void> _compartirPdf(WidgetRef ref) async {
    final bytes =
        await ref.read(exportPdfProvider.notifier).generarPdfLocal(cotizacion);
    if (bytes == null) return;
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'cotizacion_${cotizacion.id}.pdf',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(exportPdfProvider);
    final money = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Exportar PDF',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.colors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: context.colors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.picture_as_pdf_outlined,
                          size: 34, color: context.colors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cotización #${cotizacion.numero}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${cotizacion.lineas.length} materiales',
                      style: TextStyle(color: context.colors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: context.colors.divider, height: 1),
                    const SizedBox(height: 16),
                    if (cotizacion.manoObra != null) ...[
                      ResumenRow(
                        label: 'Mano de obra',
                        value: money.format(cotizacion.manoObra),
                      ),
                      const SizedBox(height: 8),
                    ],
                    ResumenRow(
                      label: 'Total',
                      value: money.format(cotizacion.total),
                      emphasize: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (vm.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    vm.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.error, fontSize: 13),
                  ),
                ),
              const Spacer(),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                      vm.loading ? null : () => _descargarPdf(context, ref),
                  icon: vm.loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.download_outlined, size: 18),
                  label: Text(vm.loading ? 'Generando…' : 'Descargar PDF'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: vm.loading ? null : () => _compartirPdf(ref),
                  icon: const Icon(Icons.ios_share_outlined, size: 18),
                  label: const Text('Compartir PDF'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
