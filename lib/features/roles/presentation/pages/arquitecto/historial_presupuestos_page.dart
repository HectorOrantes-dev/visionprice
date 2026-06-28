import 'package:flutter/material.dart';

class ArquitectoHistorialPresupuestosPage extends StatefulWidget {
  final VoidCallback? onBack;
  const ArquitectoHistorialPresupuestosPage({super.key, this.onBack});

  @override
  State<ArquitectoHistorialPresupuestosPage> createState() => _ArquitectoHistorialPresupuestosPageState();
}

class _ArquitectoHistorialPresupuestosPageState extends State<ArquitectoHistorialPresupuestosPage> {
  String _selectedFilter = 'Todas';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.blue, size: 20),
                onPressed: widget.onBack,
              )
            : null,
        title: const Text(
          'Historial de Presupuestos',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.bar_chart, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Historial',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Presupuestos supervisados',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt_outlined, color: Colors.blue),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildChip('Todas', _selectedFilter == 'Todas'),
                const SizedBox(width: 8),
                _buildChip('Torre Polanco', _selectedFilter == 'Torre Polanco'),
                const SizedBox(width: 8),
                _buildChip('Validados', _selectedFilter == 'Validados'),
                const SizedBox(width: 8),
                _buildChip('Con alerta', _selectedFilter == 'Con alerta'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Torre Polanco' || _selectedFilter == 'Con alerta')
                  _buildHistoryCard(
                    title: 'Torre Corp. — Estructura P4',
                    subtitle: 'Hoy - Aceros del Norte',
                    amount: '\$1.03M',
                    statusBadge: 'Revisión',
                    statusBadgeBg: Colors.red.withOpacity(0.1),
                    statusBadgeColor: Colors.red,
                  ),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Torre Polanco' || _selectedFilter == 'Con alerta')
                  const SizedBox(height: 12),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Torre Polanco' || _selectedFilter == 'Validados')
                  _buildHistoryCard(
                    title: 'Torre Corp. — Lobby',
                    subtitle: '12 jun - Proveedores múltiples',
                    amount: '\$642k',
                    statusBadge: 'Validado',
                    statusBadgeBg: Colors.green.withOpacity(0.1),
                    statusBadgeColor: Colors.green,
                  ),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Torre Polanco' || _selectedFilter == 'Validados')
                  const SizedBox(height: 12),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Validados')
                  _buildHistoryCard(
                    title: 'Satélite — Cimentación',
                    subtitle: '10 jun - Concretos Premium',
                    amount: '\$890k',
                    statusBadge: 'Validado',
                    statusBadgeBg: Colors.green.withOpacity(0.1),
                    statusBadgeColor: Colors.green,
                  ),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Validados')
                  const SizedBox(height: 12),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Con alerta')
                  _buildHistoryCard(
                    title: 'Cumbres — Acabados',
                    subtitle: '8 jun - Pisos y Muros SA',
                    amount: '\$1.2M',
                    statusBadge: 'Revisión',
                    statusBadgeBg: Colors.orange.withOpacity(0.1),
                    statusBadgeColor: Colors.orange[800]!,
                  ),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Con alerta')
                  const SizedBox(height: 12),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Validados')
                  _buildHistoryCard(
                    title: 'Hospital Sur — Cancelería',
                    subtitle: '5 jun - Aluminio Exprés',
                    amount: '\$180k',
                    statusBadge: 'Validado',
                    statusBadgeBg: Colors.green.withOpacity(0.1),
                    statusBadgeColor: Colors.green,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String title,
    required String subtitle,
    required String amount,
    required String statusBadge,
    required Color statusBadgeBg,
    required Color statusBadgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.description_outlined, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBadgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(statusBadge, style: TextStyle(color: statusBadgeColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
