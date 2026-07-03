import 'package:injectable/injectable.dart';

import '../entities/calculo_entity.dart';
import '../repositories/grabacion_repository.dart';

/// Calcula los m² a partir de una grabación procesada.
@injectable
class CalcularMetrosUseCase {
  final GrabacionRepository _repo;
  CalcularMetrosUseCase(this._repo);

  Future<CalculoEntity> call({required int grabacionId}) =>
      _repo.calcular(grabacionId: grabacionId);
}
