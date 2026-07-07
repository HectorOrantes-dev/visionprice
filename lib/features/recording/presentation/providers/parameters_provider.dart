import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/calculo_entity.dart';
import '../../domain/entities/grabacion_entity.dart';
import '../../domain/usecases/grabacion_usecases.dart';

/// ViewModel de la pantalla de parámetros: trae el detalle de la grabación
/// (transcripción + confianza + extracción) y el cálculo de m².
@injectable
class ParametersViewModel extends ChangeNotifier {
  final ObtenerGrabacionUseCase _obtener;
  final CalcularMetrosUseCase _calcular;
  final ActualizarTranscripcionUseCase _actualizar;
  
  ParametersViewModel(this._obtener, this._calcular, this._actualizar);

  bool _loading = true;
  String? _errorMessage;
  GrabacionEntity? _grabacion;
  CalculoEntity? _calculo;
  String? _textoEditado;

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  GrabacionEntity? get grabacion => _grabacion;
  CalculoEntity? get calculo => _calculo;
  String? get textoEditado => _textoEditado;

  Future<void> load(int grabacionId) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _grabacion = await _obtener(grabacionId);
      _calculo = await _calcular(grabacionId: grabacionId);
    } catch (e) {
      _errorMessage =
          e is ApiException ? e.message : 'No se pudo calcular los metros.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> recalcular(String texto) async {
    _textoEditado = texto;
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _calculo = await _calcular(texto: texto);
    } catch (e) {
      _errorMessage =
          e is ApiException ? e.message : 'No se pudo recalcular los metros.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> guardarEdicion(int grabacionId) async {
    if (_textoEditado != null && _textoEditado != _grabacion?.transcripcion) {
      try {
        await _actualizar(grabacionId, _textoEditado!);
      } catch (e) {
        // Si falla al guardar de forma silenciosa, podemos ignorarlo o hacer un log.
        debugPrint('Error al guardar edición: $e');
      }
    }
  }
}
