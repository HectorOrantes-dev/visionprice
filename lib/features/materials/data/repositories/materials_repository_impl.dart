import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/material_item.dart';
import '../../domain/repositories/materials_repository.dart';
import '../datasources/materials_remote_datasource.dart';

/// Implementación concreta de [MaterialsRepository] — capa Data.
@Injectable(as: MaterialsRepository)
class MaterialsRepositoryImpl implements MaterialsRepository {
  const MaterialsRepositoryImpl(this._remoteDatasource);

  final MaterialsRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, List<MaterialItem>>> getMaterials(
      String projectId) async {
    try {
      final models = await _remoteDatasource.getMaterials(projectId);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MaterialItem>> updateWastePercent({
    required String materialId,
    required double percent,
  }) async {
    try {
      final model =
          await _remoteDatasource.updateWastePercent(materialId, percent);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MaterialItem>> selectSupplier({
    required String materialId,
    required int supplierIndex,
  }) async {
    try {
      final model =
          await _remoteDatasource.selectSupplier(materialId, supplierIndex);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
