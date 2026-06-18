import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/estimate.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_remote_datasource.dart';

/// Implementación concreta de [BudgetRepository] — capa Data.
///
/// Registrada automáticamente en GetIt como implementación de [BudgetRepository]
/// gracias a la anotación [@Injectable].
@Injectable(as: BudgetRepository)
class BudgetRepositoryImpl implements BudgetRepository {
  const BudgetRepositoryImpl(this._remoteDatasource);

  final BudgetRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, Estimate>> getEstimate(String projectId) async {
    try {
      final model = await _remoteDatasource.getEstimate(projectId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> exportToPdf(Estimate estimate) async {
    try {
      final path = await _remoteDatasource.exportToPdf(estimate);
      return Right(path);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Estimate>> updateContingency(
    String estimateId,
    double percent,
  ) async {
    try {
      final model =
          await _remoteDatasource.updateContingency(estimateId, percent);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
