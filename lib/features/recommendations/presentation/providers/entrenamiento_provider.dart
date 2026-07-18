import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entrenamiento_entity.dart';
import 'recomendacion_providers.dart';

part 'entrenamiento_provider.g.dart';

/// Estado de `POST /api/v1/recomendaciones/entrenar`.
///
/// El `build()` arranca en `null` (aún no se ha entrenado en esta sesión); el
/// entrenamiento lo dispara el usuario con [entrenar]. `AsyncValue.guard`
/// traduce el resultado o el error (p. ej. 403 si el rol no es
/// `ingeniero_civil`) al subtipo correcto, sin try/catch manual.
@riverpod
class Entrenamiento extends _$Entrenamiento {
  @override
  FutureOr<EntrenamientoEntity?> build() => null;

  Future<void> entrenar() async {
    state = const AsyncLoading<EntrenamientoEntity?>();
    state = await AsyncValue.guard<EntrenamientoEntity?>(
      () => ref.read(entrenarModelosUseCaseProvider)(),
    );
  }
}
