import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/material_item.dart';

/// Contrato del repositorio de materiales — capa Domain.
abstract interface class MaterialsRepository {
  /// Obtiene la lista de materiales para un proyecto dado.
  Future<Either<Failure, List<MaterialItem>>> getMaterials(String projectId);

  /// Actualiza el porcentaje de desperdicio de un material.
  Future<Either<Failure, MaterialItem>> updateWastePercent({
    required String materialId,
    required double percent,
  });

  /// Selecciona un proveedor específico para un material.
  Future<Either<Failure, MaterialItem>> selectSupplier({
    required String materialId,
    required int supplierIndex,
  });
}
