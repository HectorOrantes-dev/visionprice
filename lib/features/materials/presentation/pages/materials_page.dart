import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/material_item.dart';

/// Datos mock para demostración
final _mockMaterials = [
  MaterialItem(
    id: 'mat_001',
    name: 'Azulejo Porcelánico 60×60',
    unit: 'm²',
    category: 'ceramic',
    quantityNeeded: 18.5,
    wastePercent: 10,
    prices: [
      SupplierPrice(
        supplier: 'Home Depot',
        pricePerUnit: 485.0,
        isRealTime: true,
        fetchedAt: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      SupplierPrice(
        supplier: 'Sodimac',
        pricePerUnit: 510.0,
        isRealTime: false,
        fetchedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      SupplierPrice(
        supplier: 'Construrama',
        pricePerUnit: 460.0,
        isRealTime: true,
        fetchedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ],
  ),
  MaterialItem(
    id: 'mat_002',
    name: 'Adhesivo Cementoso Flex',
    unit: 'saco 25kg',
    category: 'cement',
    quantityNeeded: 5,
    wastePercent: 5,
    prices: [
      SupplierPrice(
        supplier: 'Sodimac',
        pricePerUnit: 320.0,
        isRealTime: false,
        fetchedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      SupplierPrice(
        supplier: 'Construrama',
        pricePerUnit: 295.0,
        isRealTime: true,
        fetchedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ],
  ),
  MaterialItem(
    id: 'mat_003',
    name: 'Membrana Impermeabilizante',
    unit: 'litro',
    category: 'waterproofing',
    quantityNeeded: 6,
    wastePercent: 5,
    prices: [
      SupplierPrice(
        supplier: 'Home Depot',
        pricePerUnit: 280.0,
        isRealTime: true,
        fetchedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ],
  ),
  MaterialItem(
    id: 'mat_004',
    name: 'Pintura Vinílica Blanca',
    unit: 'litro',
    category: 'paint',
    quantityNeeded: 12,
    wastePercent: 8,
    prices: [
      SupplierPrice(
        supplier: 'Construrama',
        pricePerUnit: 145.0,
        isRealTime: true,
        fetchedAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      SupplierPrice(
        supplier: 'Home Depot',
        pricePerUnit: 158.0,
        isRealTime: false,
        fetchedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
  ),
];

/// Fase 5 y 6: Lista dinámica de materiales con sliders de desperdicio
/// y tarjetas de comparación de precios por proveedor
class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key, required this.projectId});

  final String projectId;

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  late List<MaterialItem> _materials;
  double _totalCost = 0;

  @override
  void initState() {
    super.initState();
    _materials = List.from(_mockMaterials);
    _recalcTotal();
  }

  void _recalcTotal() {
    _totalCost = _materials.fold(0.0, (s, m) => s + m.totalCost);
  }

  void _onWasteChanged(int index, double value) {
    setState(() {
      _materials[index] = _materials[index].copyWith(wastePercent: value);
      _recalcTotal();
    });
  }

  void _onSupplierChanged(int index, int supplierIdx) {
    setState(() {
      _materials[index] =
          _materials[index].copyWith(selectedSupplierIndex: supplierIdx);
      _recalcTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgDark,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => context.pop(),
            ),
            title: const Text('Materiales Calculados'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _totalCost.toMXNCompact,
                      style: AppTypography.textTheme.titleMedium
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _MaterialCard(
                  material: _materials[i],
                  onWasteChanged: (v) => _onWasteChanged(i, v),
                  onSupplierSelected: (idx) => _onSupplierChanged(i, idx),
                ),
                childCount: _materials.length,
              ),
            ),
          ),
        ],
      ),

      // CTA flotante
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => context.go(
                '${AppRoutes.budget}?projectId=${widget.projectId}'),
            icon: const Icon(Icons.receipt_long_outlined, size: 20),
            label: const Text('Generar Presupuesto'),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta de material con slider de desperdicio y selector de proveedor
class _MaterialCard extends StatefulWidget {
  const _MaterialCard({
    required this.material,
    required this.onWasteChanged,
    required this.onSupplierSelected,
  });

  final MaterialItem material;
  final ValueChanged<double> onWasteChanged;
  final ValueChanged<int> onSupplierSelected;

  @override
  State<_MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<_MaterialCard> {
  bool _expanded = false;

  Color get _categoryColor {
    switch (widget.material.category) {
      case 'ceramic':
        return const Color(0xFF6C63FF);
      case 'cement':
        return AppColors.warning;
      case 'paint':
        return AppColors.accent;
      case 'waterproofing':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.material;
    final selectedPrice = m.selectedPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Category dot
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _categoryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_categoryIcon(m.category),
                        color: _categoryColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name,
                            style: AppTypography.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        Text(
                          '${m.effectiveQuantity.toStringAsFixed(2)} ${m.unit} '
                          '(+${m.wastePercent.toStringAsFixed(0)}% desperdicio)',
                          style: AppTypography.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        m.totalCost.toMXN,
                        style: AppTypography.textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.textHint,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Contenido expandible
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 8),

                  // Slider de desperdicio
                  Text(
                    'Ajustar desperdicio',
                    style: AppTypography.textTheme.titleSmall
                        ?.copyWith(color: AppColors.primary),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.warning,
                      thumbColor: AppColors.warning,
                      overlayColor: AppColors.warning.withOpacity(0.15),
                    ),
                    child: Slider(
                      value: m.wastePercent,
                      min: 0,
                      max: 30,
                      divisions: 30,
                      label: '+${m.wastePercent.toStringAsFixed(0)}%',
                      onChanged: widget.onWasteChanged,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Comparador de precios
                  Text(
                    'Comparar proveedores',
                    style: AppTypography.textTheme.titleSmall
                        ?.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  ...m.prices.asMap().entries.map((entry) {
                    final i = entry.key;
                    final price = entry.value;
                    final isSelected = i == m.selectedSupplierIndex;
                    return _SupplierPriceCard(
                      price: price,
                      isSelected: isSelected,
                      isBestPrice: price.pricePerUnit ==
                          m.prices
                              .map((p) => p.pricePerUnit)
                              .reduce((a, b) => a < b ? a : b),
                      onTap: () => widget.onSupplierSelected(i),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'ceramic':
        return Icons.grid_4x4;
      case 'cement':
        return Icons.layers_outlined;
      case 'paint':
        return Icons.format_paint_outlined;
      case 'waterproofing':
        return Icons.water_drop_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }
}

/// Tarjeta de precio por proveedor con indicadores de precio en vivo / caché
class _SupplierPriceCard extends StatelessWidget {
  const _SupplierPriceCard({
    required this.price,
    required this.isSelected,
    required this.isBestPrice,
    required this.onTap,
  });

  final SupplierPrice price;
  final bool isSelected;
  final bool isBestPrice;
  final VoidCallback onTap;

  Color get _supplierColor {
    switch (price.supplier) {
      case 'Home Depot':
        return AppColors.homeDepot;
      case 'Sodimac':
        return AppColors.sodimac;
      case 'Construrama':
        return AppColors.construrama;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? _supplierColor.withOpacity(0.08)
              : AppColors.bgElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? _supplierColor.withOpacity(0.4)
                : AppColors.border,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // Supplier label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _supplierColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                price.supplier,
                style: AppTypography.textTheme.labelSmall
                    ?.copyWith(color: _supplierColor, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 8),
            // Real-time / cache badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: price.isRealTime
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    price.isRealTime ? Icons.wifi : Icons.history,
                    size: 10,
                    color: price.isRealTime
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    price.isRealTime ? 'En vivo' : price.freshnessLabel,
                    style: AppTypography.textTheme.labelSmall?.copyWith(
                      color: price.isRealTime
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),
            // Best price badge
            if (isBestPrice) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Mejor precio',
                  style: AppTypography.textTheme.labelSmall
                      ?.copyWith(color: AppColors.primary),
                ),
              ),
            ],
            const Spacer(),
            // Price
            Text(
              '\$${price.pricePerUnit.toStringAsFixed(2)}/u',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: isSelected ? _supplierColor : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? _supplierColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? _supplierColor : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
