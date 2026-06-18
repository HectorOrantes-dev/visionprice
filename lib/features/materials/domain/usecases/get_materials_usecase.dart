import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/material_item.dart';
import '../repositories/materials_repository.dart';

/// Caso de uso: Obtener lista de materiales de un proyecto.
@injectable
final class GetMaterialsUseCase {
  const GetMaterialsUseCase(this._repository);

  final MaterialsRepository _repository;

  Future<Either<Failure, List<MaterialItem>>> call(String projectId) =>
      _repository.getMaterials(projectId);
}

/// Caso de uso: Actualizar desperdicio de un material.
@injectable
final class UpdateMaterialWasteUseCase {
  const UpdateMaterialWasteUseCase(this._repository);

  final MaterialsRepository _repository;

  Future<Either<Failure, MaterialItem>> call({
    required String materialId,
    required double percent,
  }) =>
      _repository.updateWastePercent(
        materialId: materialId,
        percent: percent,
      );
}
