import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/estimate.dart';

/// Contrato del repositorio de presupuestos — capa Domain
/// Las implementaciones viven en la capa data/
abstract interface class BudgetRepository {
  /// Obtiene el presupuesto de un proyecto. Devuelve [Failure] si no existe.
  Future<Either<Failure, Estimate>> getEstimate(String projectId);

  /// Exporta el presupuesto a PDF. Devuelve la ruta del archivo generado.
  Future<Either<Failure, String>> exportToPdf(Estimate estimate);

  /// Actualiza el porcentaje de contingencia de un presupuesto.
  Future<Either<Failure, Estimate>> updateContingency(
    String estimateId,
    double percent,
  );
}
