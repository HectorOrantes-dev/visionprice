import '../../domain/entities/calculo_entity.dart';
import '../../domain/entities/grabacion_entity.dart';

/// Estado inmutable de la pantalla de parámetros (detalle de la grabación +
/// cálculo de m²).
class ParametersState {
  final bool loading;
  final String? errorMessage;
  final GrabacionEntity? grabacion;
  final CalculoEntity? calculo;
  final String? textoEditado;

  const ParametersState({
    this.loading = true,
    this.errorMessage,
    this.grabacion,
    this.calculo,
    this.textoEditado,
  });

  static const _keep = Object();

  ParametersState copyWith({
    bool? loading,
    Object? errorMessage = _keep,
    Object? grabacion = _keep,
    Object? calculo = _keep,
    Object? textoEditado = _keep,
  }) {
    return ParametersState(
      loading: loading ?? this.loading,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      grabacion:
          grabacion == _keep ? this.grabacion : grabacion as GrabacionEntity?,
      calculo: calculo == _keep ? this.calculo : calculo as CalculoEntity?,
      textoEditado: textoEditado == _keep
          ? this.textoEditado
          : textoEditado as String?,
    );
  }
}
