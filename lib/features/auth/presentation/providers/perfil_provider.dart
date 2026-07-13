import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/perfil_entity.dart';
import 'auth_providers.dart';

part 'perfil_provider.g.dart';

/// AsyncNotifier de la pantalla "Perfil". `build()` carga el perfil
/// (`GET /api/v1/me/perfil`) y Riverpod expone el resultado como
/// `AsyncValue<PerfilEntity>` (loading / data / error) automáticamente.
/// Tras la primera vez el perfil viene de la caché del repositorio.
@riverpod
class Perfil extends _$Perfil {
  @override
  Future<PerfilEntity> build() =>
      ref.read(getPerfilUseCaseProvider)();

  /// Fuerza una recarga desde el back-end. El contenido anterior permanece
  /// visible durante el `await` (sin parpadeo) y `AsyncValue.guard` captura
  /// errores sin try/catch manual.
  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(getPerfilUseCaseProvider)(forceRefresh: true),
    );
  }
}
