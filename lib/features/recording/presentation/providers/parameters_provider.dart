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
    // `load` muta `state` en su primera línea (síncrona) — Riverpod no permite
    // leer/mutar el estado mientras el propio build() aún se construye (lanza
    // "Tried to read the state of an uninitialized provider"). Se difiere con
    // microtask para que corra justo después, como en Home/Recording.
    Future.microtask(() => load(grabacionId));
    return const ParametersState(loading: true);
  }

  Future<void> load(int grabacionId) async {
    state = state.copyWith(
        loading: true, errorMessage: null, requiereAltura: false);
    try {
      final grabacion = await ref.read(obtenerGrabacionUseCaseProvider)(grabacionId);
      // Se fija la grabación de inmediato: aunque el cálculo falle abajo (p.ej.
      // "no se detectó la altura"), la transcripción queda visible/editable.
      state = state.copyWith(grabacion: grabacion);
      CalculoEntity? calculo = state.calculo;
      if (grabacion.superficies.isEmpty) {
        calculo = await ref.read(calcularMetrosUseCaseProvider)(
            grabacionId: grabacionId);
      }
      state = state.copyWith(calculo: calculo, loading: false);
    } catch (e) {
      final msg =
          e is ApiException ? e.message : 'No se pudo calcular los metros.';
      state = state.copyWith(
        loading: false,
        errorMessage: msg,
        requiereAltura: _faltaAltura(msg),
      );
    }
  }

  /// Recalcula los m² con el texto editado y, opcionalmente, la [altura] de
  /// pared capturada a mano. Usa `recalculando` (no `loading`) para no
  /// desmontar la tarjeta de transcripción con lo que el usuario escribió.
  Future<void> recalcular(String texto, {double? altura}) async {
    state = state.copyWith(
        textoEditado: texto,
        recalculando: true,
        errorMessage: null,
        requiereAltura: false);
    try {
      final calculo = await ref
          .read(calcularMetrosUseCaseProvider)(texto: texto, altura: altura);
      state = state.copyWith(
          calculo: calculo, recalculando: false, requiereAltura: false);
    } catch (e) {
      final msg =
          e is ApiException ? e.message : 'No se pudo recalcular los metros.';
      state = state.copyWith(
        recalculando: false,
        errorMessage: msg,
        requiereAltura: _faltaAltura(msg),
      );
    }
  }

  /// Heurística: el back-end no pudo derivar la altura de la pared del texto.
  bool _faltaAltura(String msg) => msg.toLowerCase().contains('altura');

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
