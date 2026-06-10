import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/estimate.dart';

part 'budget_provider.g.dart';

// ============================================================
// STATE — BudgetState
// ============================================================

/// Estado completo de la pantalla de presupuesto
final class BudgetState {
  const BudgetState({
    required this.estimate,
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

  /// Calcula el color de la barra según el porcentaje de contingencia
  /// 5% → verde, 12% → amarillo, 20% → naranja
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
      exportedPdfPath: clearPdf ? null : exportedPdfPath ?? this.exportedPdfPath,
    );
  }
}

enum ContingencyRisk { low, medium, high }

// ============================================================
// NOTIFIER — BudgetNotifier
// ============================================================

/// Notifier que gestiona el estado del presupuesto final.
///
/// Principios clave:
/// - Inmutabilidad: cada cambio genera un nuevo [BudgetState]
/// - Reactividad: Riverpod propaga los cambios automáticamente
/// - Responsabilidad única: solo calcula y exporta presupuestos
@riverpod
class BudgetNotifier extends _$BudgetNotifier {
  @override
  BudgetState build() {
    // Estado inicial con datos mock para desarrollo
    return BudgetState(
      estimate: _buildMockEstimate(),
      isLoading: false,
    );
  }

  // ──────────────────────────────────────────────────
  // LOAD
  // ──────────────────────────────────────────────────

  /// Carga el presupuesto desde el repositorio para un proyecto dado
  Future<void> loadEstimate(String projectId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // TODO: Inyectar GetBudgetUseCase via GetIt
      // final estimate = await _getBudgetUseCase(projectId);
      await Future.delayed(const Duration(seconds: 1)); // Simula latencia API
      state = state.copyWith(
        estimate: _buildMockEstimate(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo cargar el presupuesto: ${e.toString()}',
      );
    }
  }

  // ──────────────────────────────────────────────────
  // CONTINGENCY SLIDER
  // ──────────────────────────────────────────────────

  /// Se llama en tiempo real mientras el usuario mueve el slider
  /// [percent] → rango 5.0 a 20.0
  void onContingencyChanged(double percent) {
    if (state.estimate == null) return;

    final clamped = percent.clamp(5.0, 20.0);
    final updated = state.estimate!.copyWith(contingencyPercent: clamped);
    state = state.copyWith(estimate: updated, clearError: true);
  }

  // ──────────────────────────────────────────────────
  // WASTE SLIDER per line
  // ──────────────────────────────────────────────────

  /// Actualiza el desperdicio de una línea de material específica
  /// [lineId] → ID de [EstimateLine]
  /// [percent] → rango 0.0 a 30.0
  void onWastePercentChanged(String lineId, double percent) {
    if (state.estimate == null) return;

    final clamped = percent.clamp(0.0, 30.0);
    final updatedLines = state.estimate!.materialLines.map((line) {
      if (line.id == lineId) {
        return line.copyWith(wastePercent: clamped);
      }
      return line;
    }).toList();

    final updated = state.estimate!.copyWith(materialLines: updatedLines);
    state = state.copyWith(estimate: updated);
  }

  // ──────────────────────────────────────────────────
  // LABOR & EXTRAS
  // ──────────────────────────────────────────────────

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

  // ──────────────────────────────────────────────────
  // PDF EXPORT
  // ──────────────────────────────────────────────────

  /// Genera y comparte el PDF del presupuesto
  Future<void> exportToPdf() async {
    if (state.estimate == null) return;
    state = state.copyWith(isExporting: true, clearError: true);

    try {
      // TODO: Inyectar ExportPdfUseCase via GetIt
      await Future.delayed(const Duration(seconds: 2)); // Simula generación PDF
      const fakePath = '/storage/emulated/0/Downloads/presupuesto_visionprice.pdf';
      state = state.copyWith(
        isExporting: false,
        exportedPdfPath: fakePath,
      );
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: 'Error al exportar PDF: ${e.toString()}',
      );
    }
  }

  void clearExportedPdf() {
    state = state.copyWith(clearPdf: true);
  }

  // ──────────────────────────────────────────────────
  // MOCK DATA (para desarrollo sin backend)
  // ──────────────────────────────────────────────────

  Estimate _buildMockEstimate() {
    return Estimate(
      id: 'est_001',
      projectId: 'proj_001',
      projectName: 'Baño Principal - Coyoacán',
      contingencyPercent: 10.0,
      laborCost: 8500.0,
      extrasAmount: 1200.0,
      generatedAt: DateTime.now(),
      materialLines: [
        const EstimateLine(
          id: 'line_001',
          materialId: 'mat_001',
          materialName: 'Azulejo Porcelánico 60×60',
          materialCategory: 'ceramic',
          unit: 'm²',
          quantityM2: 18.5,
          wastePercent: 10.0,
          unitPrice: 485.0,
          supplierName: 'Home Depot',
          isPriceFromCache: false,
        ),
        const EstimateLine(
          id: 'line_002',
          materialId: 'mat_002',
          materialName: 'Adhesivo Cementoso Flex',
          materialCategory: 'cement',
          unit: 'saco 25kg',
          quantityM2: 5.0,
          wastePercent: 5.0,
          unitPrice: 320.0,
          supplierName: 'Sodimac',
          isPriceFromCache: true,
        ),
        const EstimateLine(
          id: 'line_003',
          materialId: 'mat_003',
          materialName: 'Pintura Vinílica Blanca',
          materialCategory: 'paint',
          unit: 'litro',
          quantityM2: 12.0,
          wastePercent: 8.0,
          unitPrice: 145.0,
          supplierName: 'Construrama',
          isPriceFromCache: false,
        ),
        const EstimateLine(
          id: 'line_004',
          materialId: 'mat_004',
          materialName: 'Crucetas 3mm',
          materialCategory: 'accessories',
          unit: 'paquete',
          quantityM2: 3.0,
          wastePercent: 0.0,
          unitPrice: 89.0,
          supplierName: 'Home Depot',
          isPriceFromCache: false,
        ),
        const EstimateLine(
          id: 'line_005',
          materialId: 'mat_005',
          materialName: 'Membrana Impermeabilizante',
          materialCategory: 'waterproofing',
          unit: 'litro',
          quantityM2: 6.0,
          wastePercent: 5.0,
          unitPrice: 280.0,
          supplierName: 'Construrama',
          isPriceFromCache: false,
        ),
      ],
    );
  }
}

// ============================================================
// COMPUTED PROVIDERS — Derivados reactivos
// ============================================================

/// Provider para el grand total actualizado en tiempo real
@riverpod
double budgetGrandTotal(Ref ref) {
  final state = ref.watch(budgetNotifierProvider);
  return state.estimate?.grandTotal ?? 0.0;
}

/// Provider para el subtotal de materiales
@riverpod
double budgetMaterialsSubtotal(Ref ref) {
  final state = ref.watch(budgetNotifierProvider);
  return state.estimate?.materialsSubtotal ?? 0.0;
}

/// Provider para el monto de contingencia
@riverpod
double budgetContingencyAmount(Ref ref) {
  final state = ref.watch(budgetNotifierProvider);
  return state.estimate?.contingencyAmount ?? 0.0;
}

/// Provider para la lista de líneas (para lista de materiales)
@riverpod
List<EstimateLine> budgetMaterialLines(Ref ref) {
  final state = ref.watch(budgetNotifierProvider);
  return state.estimate?.materialLines ?? [];
}
