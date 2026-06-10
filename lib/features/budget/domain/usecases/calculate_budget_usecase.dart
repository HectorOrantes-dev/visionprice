import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/estimate.dart';
import '../repositories/budget_repository.dart';

/// Caso de uso: Obtener presupuesto de un proyecto
/// Responsabilidad única: delegar al repositorio y devolver el resultado
final class GetBudgetUseCase {
  const GetBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  Future<Either<Failure, Estimate>> call(String projectId) {
    return _repository.getEstimate(projectId);
  }
}

/// Caso de uso: Exportar presupuesto a PDF
final class ExportPdfUseCase {
  const ExportPdfUseCase(this._repository);

  final BudgetRepository _repository;

  Future<Either<Failure, String>> call(Estimate estimate) {
    return _repository.exportToPdf(estimate);
  }
}

/// Caso de uso: Calcular presupuesto en tiempo real
/// (Actualizar contingencia)
final class UpdateContingencyUseCase {
  const UpdateContingencyUseCase(this._repository);

  final BudgetRepository _repository;

  Future<Either<Failure, Estimate>> call({
    required String estimateId,
    required double percent,
  }) {
    return _repository.updateContingency(estimateId, percent);
  }
}
