import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'budget_result_screen.dart';

class NearbyStoresScreen extends StatefulWidget {
  const NearbyStoresScreen({super.key});

  @override
  State<NearbyStoresScreen> createState() => _NearbyStoresScreenState();
}

class _NearbyStoresScreenState extends State<NearbyStoresScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Cercanía', 'Precio', 'Cobertura'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _StoresAppBar(),
            const SizedBox(height: 12),
            _FilterChips(
              selected: _selectedFilter,
              filters: _filters,
              onSelected: (i) => setState(() => _selectedFilter = i),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _StoreCard(
                    name: 'Ferretería El Constructor',
                    distance: '0.8 km',
                    neighborhood: 'Col. Del Valle',
                    badge: 'Cubre todo',
                    badgeColor: AppColors.success,
                    total: '\$84,320 MXN',
                    items: const [
                      _StoreItem('Concreto premezclado', '\$1,850/m²',
                          available: true),
                      _StoreItem('Mortero revoque', '\$185/bulto',
                          available: true),
                      _StoreItem('Varilla 3/8"', '\$87/pza', available: true),
                    ],
                    isSelected: true,
                    onSelect: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BudgetResultScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _StoreCard(
                    name: 'Materiales del Valle',
                    distance: '1.4 km',
                    neighborhood: 'Narvarte',
                    badge: 'Parcial',
                    badgeColor: AppColors.warning,
                    items: const [
                      _StoreItem('Concreto premezclado', '\$1,780/m²',
                          available: true),
                      _StoreItem('Mortero revoque', null, available: false),
                      _StoreItem('Varilla 3/8"', '\$82/pza', available: true),
                    ],
                    isSelected: false,
                    onSelect: () {},
                  ),
                  const SizedBox(height: 12),
                  _StoreCard(
                    name: 'Suministros Omega',
                    distance: '2.1 km',
                    neighborhood: 'Insurgentes Sur',
                    badge: 'Parcial',
                    badgeColor: AppColors.warning,
                    items: const [
                      _StoreItem('Concreto premezclado', '\$1,920/m²',
                          available: true),
                      _StoreItem('Mortero revoque', '\$192/bulto',
                          available: true),
                      _StoreItem('Varilla 3/8"', null, available: false),
                    ],
                    isSelected: false,
                    onSelect: () {},
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoresAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                size: 18, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on_outlined,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ferreterías cercanas',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '3 proveedores · Remodelación Cocina',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final int selected;
  final List<String> filters;
  final ValueChanged<int> onSelected;

  const _FilterChips({
    required this.selected,
    required this.filters,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(filters.length, (i) {
          final isSelected = i == selected;
          return Padding(
            padding: EdgeInsets.only(right: i < filters.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  filters[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _StoreItem {
  final String name;
  final String? price;
  final bool available;

  const _StoreItem(this.name, this.price, {required this.available});
}

class _StoreCard extends StatelessWidget {
  final String name;
  final String distance;
  final String neighborhood;
  final String badge;
  final Color badgeColor;
  final String? total;
  final List<_StoreItem> items;
  final bool isSelected;
  final VoidCallback onSelect;

  const _StoreCard({
    required this.name,
    required this.distance,
    required this.neighborhood,
    required this.badge,
    required this.badgeColor,
    this.total,
    required this.items,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isSelected)
                const Text('⭐ ', style: TextStyle(fontSize: 14)),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$distance · $neighborhood',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: item.available
                            ? AppColors.success
                            : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.available
                          ? (item.price ?? '')
                          : '— sin stock',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: item.available
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: item.available
                            ? AppColors.textPrimary
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
              )),
          if (total != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Total: $total',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: onSelect,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Seleccionar',
                      style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
