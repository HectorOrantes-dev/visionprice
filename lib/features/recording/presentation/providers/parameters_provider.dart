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
      final grabacion =
          await ref.read(obtenerGrabacionUseCaseProvider)(grabacionId);
      // Se fija la grabación de inmediato: aunque el cálculo falle abajo (p.ej.
      // "no se detectó la altura"), la transcripción queda visible/editable.
      state = state.copyWith(grabacion: grabacion);
      CalculoEntity? calculo = state.calculo;
      if (grabacion.superficies.isEmpty) {
        calculo = await ref.read(calcularMetrosUseCaseProvider)(
            grabacionId: grabacionId);
      }
      state = state.copyWith(
          calculo: calculo,
          loading: false,
          requiereParedManual: _esParedPuntual(calculo));
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
        requiereAltura: false,
        // Al recalcular por texto/altura se descarta el área manual de pared.
        areaManualM2: null);
    // Si el texto NO cambió (el usuario solo capturó la altura), se manda
    // `grabacion_id` para que el back-end reuse el largo/ancho ya detectados y
    // combine el override de altura, sin re-correr el regex sobre el mismo texto.
    final editado =
        texto.trim() != (state.grabacion?.transcripcion ?? '').trim();
    try {
      final calculo = await ref.read(calcularMetrosUseCaseProvider)(
        grabacionId: editado ? null : grabacionId,
        texto: editado ? texto : null,
        altura: altura,
      );
      state = state.copyWith(
          calculo: calculo,
          recalculando: false,
          requiereAltura: false,
          requiereParedManual: _esParedPuntual(calculo));
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

  /// Superficie puntual (una sola pared, no un cuarto): el usuario da ancho×alto,
  /// se calcula el área [paredesM2] en la app y se manda como override. El
  /// back-end descarta la advertencia de "faltan las paredes".
  Future<void> aplicarParedManual(double paredesM2) async {
    // El área se calculó en la app (ancho×alto): se fija YA para que el widget
    // MEDIDAS la muestre al instante, sin esperar la respuesta del back-end.
    state = state.copyWith(
        recalculando: true, errorMessage: null, areaManualM2: paredesM2);
    try {
      final calculo = await ref.read(calcularMetrosUseCaseProvider)(
        grabacionId: grabacionId,
        paredesM2: paredesM2,
      );
      state = state.copyWith(
          calculo: calculo,
          recalculando: false,
          requiereAltura: false,
          // Se conserva `areaManualM2` como medida autoritativa a mostrar.
          requiereParedManual: _esParedPuntual(calculo));
    } catch (e) {
      state = state.copyWith(
        recalculando: false,
        errorMessage: e is ApiException
            ? e.message
            : 'No se pudo calcular el área de la pared.',
      );
    }
  }

  /// Quita la medida de pared capturada a mano (el usuario cerró la tarjeta).
  void quitarParedManual() =>
      state = state.copyWith(areaManualM2: null, requiereParedManual: false);

  /// Heurística: el back-end no pudo derivar la altura de la pared del texto.
  bool _faltaAltura(String msg) => msg.toLowerCase().contains('altura');

  /// Heurística: es una pared puntual → no hay piso y la advertencia menciona
  /// que no se detectaron largo y ancho del cuarto.
  bool _esParedPuntual(CalculoEntity? c) {
    if (c == null || c.pisoM2 != null) return false;
    return c.advertencias.any((a) {
      final t = a.toLowerCase();
      return t.contains('largo') && t.contains('ancho');
    });
  }

  Future<void> guardarEdicion(int grabacionId) async {
    final texto = state.textoEditado;
    if (texto != null && texto != state.grabacion?.transcripcion) {
      try {
        await ref.read(actualizarTranscripcionUseCaseProvider)(
            grabacionId, texto);
      } catch (e) {
        // Falla silenciosa al guardar: solo se registra.
        debugPrint('Error al guardar edición: $e');
      }
    }
  }
}
