import 'package:flutter/material.dart';

class IngenieroHistorialAuditoriaPage extends StatefulWidget {
  final VoidCallback? onBack;
  
  const IngenieroHistorialAuditoriaPage({super.key, this.onBack});

  @override
  State<IngenieroHistorialAuditoriaPage> createState() => _IngenieroHistorialAuditoriaPageState();
}

class _IngenieroHistorialAuditoriaPageState extends State<IngenieroHistorialAuditoriaPage> {
  String _selectedFilter = 'Todas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Historial de auditoría',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: widget.onBack,
              )
            : null,
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
                  child: const Icon(Icons.history, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Historial de auditoría',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Todos los presupuestos',
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
                _buildChip('Todas', isSelected: _selectedFilter == 'Todas'),
                const SizedBox(width: 8),
                _buildChip('Con anomalía', isSelected: _selectedFilter == 'Con anomalía'),
                const SizedBox(width: 8),
                _buildChip('Aprobados', isSelected: _selectedFilter == 'Aprobados'),
                const SizedBox(width: 8),
                _buildChip('Observación', isSelected: _selectedFilter == 'Observación'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Con anomalía')
                  _buildHistoryCard(
                    title: 'Torre Corp. — Estructura P4',
                    subtitle: 'Hoy - hallazgo A-047 - acero sustitución',
                    amount: '\$1.03M',
                    statusBadge: 'Anomalía',
                    statusBadgeBg: Colors.red.withOpacity(0.1),
                    statusBadgeColor: Colors.red,
                    icon: Icons.description_outlined,
                    iconColor: Colors.red[300]!,
                    iconBgColor: Colors.red.withOpacity(0.1),
                  ),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Con anomalía')
                  const SizedBox(height: 12),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Aprobados')
                  _buildHistoryCard(
                    title: 'Vallejo — Bodega cimentación',
                    subtitle: '10 jun - sin observaciones',
                    amount: '\$148,900',
                    statusBadge: 'Aprobado',
                    statusBadgeBg: Colors.green.withOpacity(0.1),
                    statusBadgeColor: Colors.green,
                    icon: Icons.description_outlined,
                    iconColor: Colors.green[300]!,
                    iconBgColor: Colors.green.withOpacity(0.1),
                  ),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Aprobados')
                  const SizedBox(height: 12),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Observación')
                  _buildHistoryCard(
                    title: 'Satélite — Cimentación',
                    subtitle: '9 jun - 2 observaciones menores',
                    amount: '\$890k',
                    statusBadge: 'Observación',
                    statusBadgeBg: Colors.orange.withOpacity(0.1),
                    statusBadgeColor: Colors.orange[800]!,
                    icon: Icons.description_outlined,
                    iconColor: Colors.orange[300]!,
                    iconBgColor: Colors.orange.withOpacity(0.1),
                  ),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Observación')
                  const SizedBox(height: 12),
                if (_selectedFilter == 'Todas' || _selectedFilter == 'Aprobados')
                  _buildHistoryCard(
                    title: 'Centro Comercial Sur — Platea',
                    subtitle: '7 jun - aprobado',
                    amount: '\$920k',
                    statusBadge: 'Aprobado',
                    statusBadgeBg: Colors.green.withOpacity(0.1),
                    statusBadgeColor: Colors.green,
                    icon: Icons.description_outlined,
                    iconColor: Colors.green[300]!,
                    iconBgColor: Colors.green.withOpacity(0.1),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey[700],
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
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
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
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
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
