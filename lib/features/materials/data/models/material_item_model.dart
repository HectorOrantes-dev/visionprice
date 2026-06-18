import '../../domain/entities/material_item.dart';

/// DTO de SupplierPrice — capa Data.
class SupplierPriceModel extends SupplierPrice {
  const SupplierPriceModel({
    required super.supplier,
    required super.pricePerUnit,
    required super.fetchedAt,
    super.isRealTime,
    super.region,
  });

  factory SupplierPriceModel.fromJson(Map<String, dynamic> json) {
    return SupplierPriceModel(
      supplier: json['supplier'] as String,
      pricePerUnit: (json['price_per_unit'] as num).toDouble(),
      fetchedAt: DateTime.parse(json['fetched_at'] as String),
      isRealTime: json['is_real_time'] as bool? ?? false,
      region: json['region'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'supplier': supplier,
        'price_per_unit': pricePerUnit,
        'fetched_at': fetchedAt.toIso8601String(),
        'is_real_time': isRealTime,
        'region': region,
      };
}

/// DTO de MaterialItem — capa Data.
class MaterialItemModel extends MaterialItem {
  const MaterialItemModel({
    required super.id,
    required super.name,
    required super.unit,
    required super.category,
    required super.prices,
    super.wastePercent,
    super.quantityNeeded,
    super.selectedSupplierIndex,
    super.imageUrl,
  });

  factory MaterialItemModel.fromJson(Map<String, dynamic> json) {
    final prices = (json['prices'] as List<dynamic>)
        .map((e) => SupplierPriceModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return MaterialItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
      category: json['category'] as String,
      prices: prices,
      wastePercent: (json['waste_percent'] as num?)?.toDouble() ?? 10.0,
      quantityNeeded: (json['quantity_needed'] as num?)?.toDouble() ?? 0.0,
      selectedSupplierIndex: json['selected_supplier_index'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unit': unit,
        'category': category,
        'prices': prices
            .map((p) => SupplierPriceModel(
                  supplier: p.supplier,
                  pricePerUnit: p.pricePerUnit,
                  fetchedAt: p.fetchedAt,
                  isRealTime: p.isRealTime,
                  region: p.region,
                ).toJson())
            .toList(),
        'waste_percent': wastePercent,
        'quantity_needed': quantityNeeded,
        'selected_supplier_index': selectedSupplierIndex,
        'image_url': imageUrl,
      };
}
