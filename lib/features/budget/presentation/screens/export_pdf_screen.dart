import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../providers/export_pdf_provider.dart';
import '../widgets/pdf_link.dart';

class ExportPdfScreen extends StatelessWidget {
  final CotizacionEntity cotizacion;
  const ExportPdfScreen({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ExportPdfViewModel>(),
      child: Consumer<ExportPdfViewModel>(
        builder: (context, vm, _) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: const BackButton(color: AppColors.textPrimary),
            title: const Text('Exportar PDF',
                style: TextStyle(
                  color: AppColors.textPrimary,
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
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.picture_as_pdf_outlined,
                            size: 48, color: AppColors.primary),
                        const SizedBox(height: 12),
                        Text(
                          'Cotización #${cotizacion.id}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cotizacion.lineas.length} materiales',
                          style: const TextStyle(color: AppColors.textSecondary),
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
                      onPressed:
                          vm.loading ? null : () => vm.descargar(cotizacion.id),
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
        ),
      ),
    );
  }
}
