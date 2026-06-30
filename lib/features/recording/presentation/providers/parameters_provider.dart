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
  ParametersViewModel(this._obtener, this._calcular);

  bool _loading = true;
  String? _errorMessage;
  GrabacionEntity? _grabacion;
  CalculoEntity? _calculo;

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  GrabacionEntity? get grabacion => _grabacion;
  CalculoEntity? get calculo => _calculo;

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
}
