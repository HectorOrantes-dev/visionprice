import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/estimate.dart';
import '../../domain/usecases/calculate_budget_usecase.dart';

part 'budget_viewmodel.g.dart';

// ────────────────────────────────────────────────────────────
// Estado
// ────────────────────────────────────────────────────────────

/// Estado completo de la pantalla de presupuesto.
final class BudgetState {
  const BudgetState({
    this.estimate,
    this.isLoading = false,
    this.isExporting = false,
    this.errorMessage,
    this.exportedPdfPath,
  });

  final Estimate? estimate;
  final bool isLoading;
  final bool isExporting;
  final String? errorMessage;
  final String? exportedPdfPath;

  bool get hasError => errorMessage != null;
  bool get hasEstimate => estimate != null;

  /// Nivel de riesgo de la contingencia actual.
  ContingencyRisk get contingencyRisk {
    final pct = estimate?.contingencyPercent ?? 10;
    if (pct <= 8) return ContingencyRisk.low;
    if (pct <= 14) return ContingencyRisk.medium;
    return ContingencyRisk.high;
  }

  BudgetState copyWith({
    Estimate? estimate,
    bool? isLoading,
    bool? isExporting,
    String? errorMessage,
    String? exportedPdfPath,
    bool clearError = false,
    bool clearPdf = false,
  }) {
    return BudgetState(
      estimate: estimate ?? this.estimate,
      isLoading: isLoading ?? this.isLoading,
      isExporting: isExporting ?? this.isExporting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      exportedPdfPath:
          clearPdf ? null : exportedPdfPath ?? this.exportedPdfPath,
    );
  }
}

enum ContingencyRisk { low, medium, high }

// ────────────────────────────────────────────────────────────
// ViewModel
// ────────────────────────────────────────────────────────────

/// ViewModel del presupuesto — migrado desde BudgetNotifier (Riverpod provider).
///
/// Ahora obtiene los use cases reales desde GetIt en lugar de TODOs.
@riverpod
class BudgetViewModel extends _$BudgetViewModel {
  @override
  BudgetState build() => const BudgetState();

  // Accesores hacia GetIt
  GetBudgetUseCase get _getBudget => getIt<GetBudgetUseCase>();
  ExportPdfUseCase get _exportPdf => getIt<ExportPdfUseCase>();

  // ── LOAD ────────────────────────────────────────────────

  /// Carga el presupuesto desde el repositorio.
  Future<void> loadEstimate(String projectId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getBudget(projectId);
    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (estimate) => state.copyWith(isLoading: false, estimate: estimate),
    );
  }

  // ── CONTINGENCY SLIDER ──────────────────────────────────

  /// Actualiza la contingencia en tiempo real (mientras el usuario mueve el slider).
  void onContingencyChanged(double percent) {
    if (state.estimate == null) return;
    final clamped = percent.clamp(5.0, 20.0);
    state = state.copyWith(
      estimate: state.estimate!.copyWith(contingencyPercent: clamped),
      clearError: true,
    );
  }

  // ── WASTE SLIDER por línea ──────────────────────────────

  /// Actualiza el desperdicio de una línea de material.
  void onWastePercentChanged(String lineId, double percent) {
    if (state.estimate == null) return;
    final clamped = percent.clamp(0.0, 30.0);
    final updatedLines = state.estimate!.materialLines.map((line) {
      return line.id == lineId ? line.copyWith(wastePercent: clamped) : line;
    }).toList();
    state =
        state.copyWith(estimate: state.estimate!.copyWith(materialLines: updatedLines));
  }

  // ── LABOR & EXTRAS ──────────────────────────────────────

  void onLaborCostChanged(double value) {
    if (state.estimate == null) return;
    state = state.copyWith(
      estimate: state.estimate!.copyWith(laborCost: value.clamp(0, double.infinity)),
    );
  }

  void onExtrasChanged(double value) {
    if (state.estimate == null) return;
    state = state.copyWith(
      estimate: state.estimate!.copyWith(extrasAmount: value.clamp(0, double.infinity)),
    );
  }

  // ── PDF EXPORT ──────────────────────────────────────────

  /// Exporta el presupuesto a PDF usando el use case real.
  Future<void> exportToPdf() async {
    if (state.estimate == null) return;
    state = state.copyWith(isExporting: true, clearError: true);
    final result = await _exportPdf(state.estimate!);
    state = result.fold(
      (failure) =>
          state.copyWith(isExporting: false, errorMessage: failure.message),
      (path) => state.copyWith(isExporting: false, exportedPdfPath: path),
    );
  }

  void clearExportedPdf() => state = state.copyWith(clearPdf: true);
}

// ────────────────────────────────────────────────────────────
// Providers derivados — computados reactivos
// ────────────────────────────────────────────────────────────

@riverpod
double budgetGrandTotal(Ref ref) {
  return ref.watch(budgetViewModelProvider).estimate?.grandTotal ?? 0.0;
}

@riverpod
double budgetMaterialsSubtotal(Ref ref) {
  return ref.watch(budgetViewModelProvider).estimate?.materialsSubtotal ?? 0.0;
}

@riverpod
double budgetContingencyAmount(Ref ref) {
  return ref.watch(budgetViewModelProvider).estimate?.contingencyAmount ?? 0.0;
}

@riverpod
List<EstimateLine> budgetMaterialLines(Ref ref) {
  return ref.watch(budgetViewModelProvider).estimate?.materialLines ?? [];
}
