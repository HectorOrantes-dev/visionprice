import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/cotizacion_pdf_entity.dart';
import 'budget_providers.dart';

part 'mis_pdfs_provider.g.dart';

/// AsyncNotifier de "Mis Cotizaciones" (`GET /api/v1/cotizaciones/pdfs`).
///
/// Estrategia **cache-first**: si la base local del teléfono ya tiene el
/// listado, se devuelve de inmediato (la UI NO muestra spinner) y el back-end se
/// consulta en segundo plano para actualizar. El `AsyncLoading` solo aparece la
/// primera vez, cuando todavía no hay nada cacheado.
@riverpod
class MisPdfs extends _$MisPdfs {
  @override
  Future<List<CotizacionPdfEntity>> build() async {
    final cache = await ref.read(listarCotizacionesPdfLocalesUseCaseProvider)();
    if (cache.isNotEmpty) {
      // Hay datos guardados: se pintan ya y se refresca sin bloquear la UI.
      _refrescarEnSegundoPlano();
      return cache;
    }
    // Primera vez (sin caché): aquí sí se espera al back-end.
    return ref.read(listarCotizacionesPdfUseCaseProvider)();
  }

  /// Refresco silencioso: no toca el estado a `AsyncLoading`, así que la lista
  /// cacheada permanece visible. Solo reemplaza el estado si trajo datos.
  Future<void> _refrescarEnSegundoPlano() async {
    final res = await AsyncValue.guard(
      () => ref.read(listarCotizacionesPdfUseCaseProvider)(),
    );
    if (!ref.mounted) return;
    if (res.hasValue) state = res;
  }

  /// Refresco explícito (pull-to-refresh). Mantiene la lista visible mientras
  /// llega la respuesta; si el back-end falla, el repositorio devuelve la caché.
  Future<void> refrescar() async {
    final res = await AsyncValue.guard(
      () => ref.read(listarCotizacionesPdfUseCaseProvider)(),
    );
    if (!ref.mounted) return;
    state = res;
  }
}
