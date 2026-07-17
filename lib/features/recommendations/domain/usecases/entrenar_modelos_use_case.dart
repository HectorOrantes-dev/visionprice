import '../entities/entrenamiento_entity.dart';
import '../repositories/recomendacion_repository.dart';

/// Entrena el árbol Gini y el K-NN con las obras acumuladas (reales del usuario
/// + sintéticas). Solo lo permite el back-end para el rol `ingeniero_civil`.
class EntrenarModelosUseCase {
  final RecomendacionRepository _repo;
  EntrenarModelosUseCase(this._repo);

  Future<EntrenamientoEntity> call() => _repo.entrenar();
}
