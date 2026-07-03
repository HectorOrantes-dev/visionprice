import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../providers/export_pdf_provider.dart';

class ExportPdfScreen extends StatelessWidget {
  final CotizacionEntity cotizacion;
  const ExportPdfScreen({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ExportPdfViewModel>(),
      child: _ExportPdfView(cotizacion: cotizacion),
    );
  }
}

class _ExportPdfView extends StatelessWidget {
  final CotizacionEntity cotizacion;
  const _ExportPdfView({required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExportPdfViewModel>();
    return Scaffold(
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
              if (vm.pdfUrl != null) _PdfLink(url: vm.pdfUrl!),
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
                      : () => vm.descargar(cotizacion.id),
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

class _PdfLink extends StatelessWidget {
  final String url;
  const _PdfLink({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              url,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18, color: AppColors.primary),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enlace copiado')),
              );
            },
          ),
        ],
      ),
    );
  }
}
