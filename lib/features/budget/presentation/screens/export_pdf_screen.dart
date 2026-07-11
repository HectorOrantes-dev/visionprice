import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../providers/export_pdf_provider.dart';
import '../widgets/pdf_link.dart';

class ExportPdfScreen extends ConsumerWidget {
  final CotizacionEntity cotizacion;
  const ExportPdfScreen({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(exportPdfProvider);
    final notifier = ref.read(exportPdfProvider.notifier);
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
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.picture_as_pdf_outlined,
                            size: 48, color: context.colors.primary),
                        const SizedBox(height: 12),
                        Text(
                          'Cotización #${cotizacion.id}',
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (vm.pdfUrl != null) PdfLink(url: vm.pdfUrl!),
                  if (vm.errorMessage != null)
                    Text(
                      vm.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  const Spacer(),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: vm.loading
                          ? null
                          : () => notifier.descargar(cotizacion.id),
                      icon: vm.loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.download_outlined, size: 18),
                      label: Text(vm.loading ? 'Generando…' : 'Generar PDF'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
