import '../../domain/entities/estimate.dart';

/// Modelo DTO de EstimateLine para la capa Data.
/// Extiende la entidad pura del dominio añadiendo serialización JSON.
class EstimateLineModel extends EstimateLine {
  const EstimateLineModel({
    required super.id,
    required super.materialId,
    required super.materialName,
    required super.materialCategory,
    required super.unit,
    required super.quantityM2,
    required super.wastePercent,
    required super.unitPrice,
    required super.supplierName,
    super.isPriceFromCache,
    super.priceFetchedAt,
  });

  factory EstimateLineModel.fromJson(Map<String, dynamic> json) {
    return EstimateLineModel(
      id: json['id'] as String,
      materialId: json['material_id'] as String,
      materialName: json['material_name'] as String,
      materialCategory: json['material_category'] as String,
      unit: json['unit'] as String,
      quantityM2: (json['quantity_m2'] as num).toDouble(),
      wastePercent: (json['waste_percent'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      supplierName: json['supplier_name'] as String,
      isPriceFromCache: json['is_price_from_cache'] as bool? ?? false,
      priceFetchedAt: json['price_fetched_at'] != null
          ? DateTime.parse(json['price_fetched_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'material_id': materialId,
        'material_name': materialName,
        'material_category': materialCategory,
        'unit': unit,
        'quantity_m2': quantityM2,
        'waste_percent': wastePercent,
        'unit_price': unitPrice,
        'supplier_name': supplierName,
        'is_price_from_cache': isPriceFromCache,
        'price_fetched_at': priceFetchedAt?.toIso8601String(),
      };

  factory EstimateLineModel.fromEntity(EstimateLine entity) {
    return EstimateLineModel(
      id: entity.id,
      materialId: entity.materialId,
      materialName: entity.materialName,
      materialCategory: entity.materialCategory,
      unit: entity.unit,
      quantityM2: entity.quantityM2,
      wastePercent: entity.wastePercent,
      unitPrice: entity.unitPrice,
      supplierName: entity.supplierName,
      isPriceFromCache: entity.isPriceFromCache,
      priceFetchedAt: entity.priceFetchedAt,
    );
  }
}

/// Modelo DTO de Estimate para la capa Data.
class EstimateModel extends Estimate {
  const EstimateModel({
    required super.id,
    required super.projectId,
    required super.projectName,
    required super.materialLines,
    required super.contingencyPercent,
    required super.generatedAt,
    super.laborCost,
    super.extrasAmount,
    super.pdfUrl,
    super.isPdfExported,
  });

  factory EstimateModel.fromJson(Map<String, dynamic> json) {
    final lines = (json['material_lines'] as List<dynamic>)
        .map((e) => EstimateLineModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return EstimateModel(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      projectName: json['project_name'] as String,
      materialLines: lines,
      contingencyPercent: (json['contingency_percent'] as num).toDouble(),
      generatedAt: DateTime.parse(json['generated_at'] as String),
      laborCost: (json['labor_cost'] as num?)?.toDouble() ?? 0,
      extrasAmount: (json['extras_amount'] as num?)?.toDouble() ?? 0,
      pdfUrl: json['pdf_url'] as String?,
      isPdfExported: json['is_pdf_exported'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'project_id': projectId,
        'project_name': projectName,
        'material_lines': materialLines
            .map((l) => EstimateLineModel.fromEntity(l).toJson())
            .toList(),
        'contingency_percent': contingencyPercent,
        'generated_at': generatedAt.toIso8601String(),
        'labor_cost': laborCost,
        'extras_amount': extrasAmount,
        'pdf_url': pdfUrl,
        'is_pdf_exported': isPdfExported,
      };
}
