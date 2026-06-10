import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/estimate.dart';

/// Contrato de repositorio para presupuestos — capa Domain
abstract interface class BudgetRepository {
  /// Obtiene o genera el presupuesto de un proyecto
  Future<Either<Failure, Estimate>> getEstimate(String projectId);

  /// Actualiza el porcentaje de contingencia
  Future<Either<Failure, Estimate>> updateContingency(
    String estimateId,
    double percent,
  );

  /// Actualiza el desperdicio de una línea de material
  Future<Either<Failure, Estimate>> updateWastePercent(
    String estimateId,
    String lineId,
    double wastePercent,
  );

  /// Exporta el presupuesto a PDF y retorna la ruta del archivo
  Future<Either<Failure, String>> exportToPdf(Estimate estimate);

  /// Guarda el presupuesto en caché local
  Future<Either<Failure, void>> cacheEstimate(Estimate estimate);
}
