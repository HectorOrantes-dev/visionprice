import '../../domain/entities/calculo_entity.dart';
import '../../domain/entities/grabacion_entity.dart';

/// Estado inmutable de la pantalla de parámetros (detalle de la grabación +
/// cálculo de m²).
class ParametersState {
  final bool loading;

  /// `true` mientras corre un **recalcular** (edición manual del texto o altura),
  /// distinto de [loading] que es la carga inicial. Se usa para NO desmontar la
  /// tarjeta de transcripción durante el recálculo.
  final bool recalculando;
  final String? errorMessage;

  /// `true` cuando el back-end reportó que no detectó la altura de la pared: la
  /// UI muestra un campo para capturarla y volver a calcular.
  final bool requiereAltura;
  final GrabacionEntity? grabacion;
  final CalculoEntity? calculo;
  final String? textoEditado;

  const ParametersState({
    this.loading = true,
    this.recalculando = false,
    this.errorMessage,
    this.requiereAltura = false,
    this.grabacion,
    this.calculo,
    this.textoEditado,
  });

  static const _keep = Object();

  ParametersState copyWith({
    bool? loading,
    bool? recalculando,
    Object? errorMessage = _keep,
    bool? requiereAltura,
    Object? grabacion = _keep,
    Object? calculo = _keep,
    Object? textoEditado = _keep,
  }) {
    return ParametersState(
      loading: loading ?? this.loading,
      recalculando: recalculando ?? this.recalculando,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      requiereAltura: requiereAltura ?? this.requiereAltura,
      grabacion:
          grabacion == _keep ? this.grabacion : grabacion as GrabacionEntity?,
      calculo: calculo == _keep ? this.calculo : calculo as CalculoEntity?,
      textoEditado: textoEditado == _keep
          ? this.textoEditado
          : textoEditado as String?,
    );
  }
}
