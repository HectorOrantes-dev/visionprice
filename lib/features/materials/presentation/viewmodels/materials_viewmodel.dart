import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/material_item.dart';
import '../../domain/usecases/get_materials_usecase.dart';

part 'materials_viewmodel.g.dart';

// ────────────────────────────────────────────────────────────
// Estado
// ────────────────────────────────────────────────────────────

sealed class MaterialsState {
  const MaterialsState();
}

final class MaterialsInitial extends MaterialsState {
  const MaterialsInitial();
}

final class MaterialsLoading extends MaterialsState {
  const MaterialsLoading();
}

final class MaterialsLoaded extends MaterialsState {
  const MaterialsLoaded(this.materials);
  final List<MaterialItem> materials;

  double get totalCost =>
      materials.fold(0.0, (sum, m) => sum + m.totalCost);
}

final class MaterialsError extends MaterialsState {
  const MaterialsError(this.message);
  final String message;
}

// ────────────────────────────────────────────────────────────
// ViewModel
// ────────────────────────────────────────────────────────────

@riverpod
class MaterialsViewModel extends _$MaterialsViewModel {
  @override
  MaterialsState build() => const MaterialsInitial();

  GetMaterialsUseCase get _getMaterials => getIt<GetMaterialsUseCase>();
  UpdateMaterialWasteUseCase get _updateWaste =>
      getIt<UpdateMaterialWasteUseCase>();

  /// Carga materiales para un proyecto dado.
  Future<void> loadMaterials(String projectId) async {
    state = const MaterialsLoading();
    final result = await _getMaterials(projectId);
    state = result.fold(
      (failure) => MaterialsError(failure.message),
      (materials) => MaterialsLoaded(materials),
    );
  }

  /// Actualiza el desperdicio de un material (slider en tiempo real).
  Future<void> updateWastePercent({
    required String materialId,
    required double percent,
  }) async {
    if (state is! MaterialsLoaded) return;
    final current = (state as MaterialsLoaded).materials;

    // Optimistic update local
    final updatedList = current.map((m) {
      return m.id == materialId ? m.copyWith(wastePercent: percent) : m;
    }).toList();
    state = MaterialsLoaded(updatedList);

    // Sincronizar con el repositorio en background
    final result = await _updateWaste(materialId: materialId, percent: percent);
    result.fold(
      (failure) => state = MaterialsError(failure.message),
      (_) {}, // Ya actualizado localmente
    );
  }

  /// Selecciona un proveedor diferente para un material.
  void selectSupplier(String materialId, int supplierIndex) {
    if (state is! MaterialsLoaded) return;
    final current = (state as MaterialsLoaded).materials;
    final updatedList = current.map((m) {
      return m.id == materialId
          ? m.copyWith(selectedSupplierIndex: supplierIndex)
          : m;
    }).toList();
    state = MaterialsLoaded(updatedList);
  }
}
