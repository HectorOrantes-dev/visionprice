import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/calculo_entity.dart';
import 'parameters_state.dart';
import 'recording_providers.dart';

export 'parameters_state.dart';

part 'parameters_provider.g.dart';

/// Notifier `.family` (por `grabacionId`) de la pantalla de parámetros. Trae el
/// detalle de la grabación (transcripción + confianza + extracción) y el
/// cálculo de m². Reemplaza al antiguo `ParametersViewModel` (ChangeNotifier).
@riverpod
class Parameters extends _$Parameters {
  @override
  ParametersState build(int grabacionId) {
    load(grabacionId);
    return const ParametersState(loading: true);
  }

  Future<void> load(int grabacionId) async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final grabacion = await ref.read(obtenerGrabacionUseCaseProvider)(grabacionId);
      CalculoEntity? calculo = state.calculo;
      if (grabacion.superficies.isEmpty) {
        calculo = await ref.read(calcularMetrosUseCaseProvider)(
            grabacionId: grabacionId);
      }
      state = state.copyWith(
          grabacion: grabacion, calculo: calculo, loading: false);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage:
            e is ApiException ? e.message : 'No se pudo calcular los metros.',
      );
    }
  }

  Future<void> recalcular(String texto) async {
    state = state.copyWith(
        textoEditado: texto, loading: true, errorMessage: null);
    try {
      final calculo = await ref.read(calcularMetrosUseCaseProvider)(texto: texto);
      state = state.copyWith(calculo: calculo, loading: false);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage:
            e is ApiException ? e.message : 'No se pudo recalcular los metros.',
      );
    }
  }

  Future<void> guardarEdicion(int grabacionId) async {
    final texto = state.textoEditado;
    if (texto != null && texto != state.grabacion?.transcripcion) {
      try {
        await ref.read(actualizarTranscripcionUseCaseProvider)(grabacionId, texto);
      } catch (e) {
        // Falla silenciosa al guardar: solo se registra.
        debugPrint('Error al guardar edición: $e');
      }
    }
  }
}
