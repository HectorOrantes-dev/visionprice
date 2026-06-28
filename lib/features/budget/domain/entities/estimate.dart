import 'package:equatable/equatable.dart';

/// Línea individual de material en el presupuesto
class EstimateLine extends Equatable {
  const EstimateLine({
    required this.id,
    required this.materialId,
    required this.materialName,
    required this.materialCategory,
    required this.unit,
    required this.quantityM2,
    required this.wastePercent,
    required this.unitPrice,
    required this.supplierName,
    this.isPriceFromCache = false,
    this.priceFetchedAt,
  });

  final String id;
  final String materialId;
  final String materialName;
  final String materialCategory; // 'ceramic', 'cement', 'paint', etc.
  final String unit; // 'm²', 'pieza', 'kg', 'litro'
  final double quantityM2;

  /// Porcentaje de desperdicio 0–30% — controlado por Slider en UI
  final double wastePercent;

  final double unitPrice;
  final String supplierName;
  final bool isPriceFromCache;
  final DateTime? priceFetchedAt;

  /// Cantidad efectiva considerando desperdicio
  double get effectiveQuantity => quantityM2 * (1 + wastePercent / 100);

  /// Subtotal de esta línea
  double get subtotal => effectiveQuantity * unitPrice;

  EstimateLine copyWith({
    String? id,
    String? materialId,
    String? materialName,
    String? materialCategory,
    String? unit,
    double? quantityM2,
    double? wastePercent,
    double? unitPrice,
    String? supplierName,
    bool? isPriceFromCache,
    DateTime? priceFetchedAt,
  }) {
    return EstimateLine(
      id: id ?? this.id,
      materialId: materialId ?? this.materialId,
      materialName: materialName ?? this.materialName,
      materialCategory: materialCategory ?? this.materialCategory,
      unit: unit ?? this.unit,
      quantityM2: quantityM2 ?? this.quantityM2,
      wastePercent: wastePercent ?? this.wastePercent,
      unitPrice: unitPrice ?? this.unitPrice,
      supplierName: supplierName ?? this.supplierName,
      isPriceFromCache: isPriceFromCache ?? this.isPriceFromCache,
      priceFetchedAt: priceFetchedAt ?? this.priceFetchedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        materialId,
        quantityM2,
        wastePercent,
        unitPrice,
        supplierName,
      ];
}

/// Presupuesto completo de un proyecto
class Estimate extends Equatable {
  const Estimate({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.materialLines,
    required this.contingencyPercent,
    required this.generatedAt,
    this.laborCost = 0,
    this.extrasAmount = 0,
    this.pdfUrl,
    this.isPdfExported = false,
  });

  final String id;
  final String projectId;
  final String projectName;
  final List<EstimateLine> materialLines;

  /// Costo de mano de obra en MXN
  final double laborCost;

  /// Porcentaje de contingencia — 5% a 20% — controlado por Slider
  final double contingencyPercent;

  /// Extras (herramientas, traslados, etc.)
  final double extrasAmount;

  final DateTime generatedAt;
  final String? pdfUrl;
  final bool isPdfExported;

  // ============ CÁLCULOS DERIVADOS ============

  /// Suma de todos los materiales (con desperdicio)
  double get materialsSubtotal =>
      materialLines.fold(0.0, (sum, line) => sum + line.subtotal);

  /// Base imponible para contingencia
  double get _baseForContingency => materialsSubtotal + laborCost;

  /// Monto de contingencia
  double get contingencyAmount =>
      _baseForContingency * contingencyPercent / 100;

  /// Total general
  double get grandTotal =>
      materialsSubtotal + laborCost + contingencyAmount + extrasAmount;

  /// IVA 16%
  double get ivaAmount => grandTotal * 0.16;

  /// Total con IVA
  double get grandTotalWithIva => grandTotal + ivaAmount;

  Estimate copyWith({
    String? id,
    String? projectId,
    String? projectName,
    List<EstimateLine>? materialLines,
    double? laborCost,
    double? contingencyPercent,
    double? extrasAmount,
    DateTime? generatedAt,
    String? pdfUrl,
    bool? isPdfExported,
  }) {
    return Estimate(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      materialLines: materialLines ?? this.materialLines,
      laborCost: laborCost ?? this.laborCost,
      contingencyPercent: contingencyPercent ?? this.contingencyPercent,
      extrasAmount: extrasAmount ?? this.extrasAmount,
      generatedAt: generatedAt ?? this.generatedAt,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      isPdfExported: isPdfExported ?? this.isPdfExported,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        materialLines,
        laborCost,
        contingencyPercent,
        extrasAmount,
      ];
}
