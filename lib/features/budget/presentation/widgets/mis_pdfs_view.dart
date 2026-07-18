import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/mis_pdfs_provider.dart';
import 'cotizacion_pdf_card.dart';
import 'mis_pdfs_empty.dart';
import 'mis_pdfs_error.dart';

/// Contenido de la pestaña "Mis Cotizaciones": lista todas las cotizaciones/PDFs del
/// usuario (todas sus obras). Consume el `AsyncValue` de `misPdfsProvider` de
/// forma exhaustiva con `.when()` (loading / error / data).
class MisPdfsView extends ConsumerWidget {
  const MisPdfsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pdfsAsync = ref.watch(misPdfsProvider);
    final c = context.colors;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Mis Cotizaciones',
                style: AppTextStyles.heading(size: 24, color: c.textPrimary)),
          ),
        ),
        Expanded(
          child: pdfsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => MisPdfsError(
              message: e is ApiException
                  ? e.message
                  : 'No se pudieron cargar tus cotizaciones.',
              onRetry: () => ref.invalidate(misPdfsProvider),
            ),
            data: (pdfs) {
              if (pdfs.isEmpty) return const MisPdfsEmpty();
              return RefreshIndicator(
                // Refresco explícito contra el back-end (el `build()` es
                // cache-first, así que `refresh` sobre él devolvería la caché).
                onRefresh: () =>
                    ref.read(misPdfsProvider.notifier).refrescar(),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  itemCount: pdfs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => CotizacionPdfCard(pdf: pdfs[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
