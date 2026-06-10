import 'package:equatable/equatable.dart';

/// Precio de un proveedor para un material
final class SupplierPrice extends Equatable {
  const SupplierPrice({
    required this.supplier,
    required this.pricePerUnit,
    required this.fetchedAt,
    this.isRealTime = false,
    this.region,
  });

  final String supplier;
  final double pricePerUnit;
  final bool isRealTime;
  final DateTime fetchedAt;
  final String? region;

  /// Cuántos minutos/horas tiene el precio
  String get freshnessLabel {
    final diff = DateTime.now().difference(fetchedAt);
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    return 'Hace ${diff.inDays}d';
  }

  @override
  List<Object?> get props =>
      [supplier, pricePerUnit, isRealTime, fetchedAt, region];
}

/// Material con precios de múltiples proveedores
final class MaterialItem extends Equatable {
  const MaterialItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.category,
    required this.prices,
    this.wastePercent = 10.0,
    this.quantityNeeded = 0.0,
    this.selectedSupplierIndex = 0,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String unit;
  final String category;
  final List<SupplierPrice> prices;

  /// Porcentaje de desperdicio ajustable por slider (0–30%)
  final double wastePercent;

  /// Cantidad base calculada por el backend
  final double quantityNeeded;

  /// Proveedor seleccionado actualmente
  final int selectedSupplierIndex;

  final String? imageUrl;

  SupplierPrice? get selectedPrice =>
      prices.isNotEmpty ? prices[selectedSupplierIndex] : null;

  double get effectiveQuantity => quantityNeeded * (1 + wastePercent / 100);

  double get totalCost =>
      effectiveQuantity * (selectedPrice?.pricePerUnit ?? 0);

  /// ¿Tiene precio en tiempo real de algún proveedor?
  bool get hasRealTimePrice => prices.any((p) => p.isRealTime);

  MaterialItem copyWith({
    String? id,
    String? name,
    String? unit,
    String? category,
    List<SupplierPrice>? prices,
    double? wastePercent,
    double? quantityNeeded,
    int? selectedSupplierIndex,
    String? imageUrl,
  }) {
    return MaterialItem(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      prices: prices ?? this.prices,
      wastePercent: wastePercent ?? this.wastePercent,
      quantityNeeded: quantityNeeded ?? this.quantityNeeded,
      selectedSupplierIndex:
          selectedSupplierIndex ?? this.selectedSupplierIndex,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, unit, category, wastePercent, quantityNeeded, selectedSupplierIndex];
}
