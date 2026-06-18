import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/estimate.dart';
import '../repositories/budget_repository.dart';

/// Caso de uso: Obtener presupuesto de un proyecto.
@injectable
final class GetBudgetUseCase {
  const GetBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  Future<Either<Failure, Estimate>> call(String projectId) {
    return _repository.getEstimate(projectId);
  }
}

/// Caso de uso: Exportar presupuesto a PDF.
@injectable
final class ExportPdfUseCase {
  const ExportPdfUseCase(this._repository);

  final BudgetRepository _repository;

  Future<Either<Failure, String>> call(Estimate estimate) {
    return _repository.exportToPdf(estimate);
  }
}

/// Caso de uso: Actualizar el porcentaje de contingencia.
@injectable
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
