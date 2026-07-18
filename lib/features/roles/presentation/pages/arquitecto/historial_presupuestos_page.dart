import 'package:flutter/material.dart';

class ArquitectoHistorialPresupuestosPage extends StatelessWidget {
  const ArquitectoHistorialPresupuestosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            const Text(
              'Vista 10 / 10',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Text(
              'Historial de Presupuestos',
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: const Text(
                'Arquitecto',
                style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
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
                _buildChip('Todas', isSelected: true),
                const SizedBox(width: 8),
                _buildChip('Torre Polanco'),
                const SizedBox(width: 8),
                _buildChip('Validados'),
                const SizedBox(width: 8),
                _buildChip('Con alerta'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildHistoryCard(
                  title: 'Torre Corp. — Estructura P4',
                  subtitle: 'Hoy - Aceros del Norte',
                  amount: '\$1.03M',
                  statusBadge: 'Revisión',
                  statusBadgeBg: Colors.red.withOpacity(0.1),
                  statusBadgeColor: Colors.red,
                ),
                const SizedBox(height: 12),
                _buildHistoryCard(
                  title: 'Torre Corp. — Lobby',
                  subtitle: '12 jun - Proveedores múltiples',
                  amount: '\$642k',
                  statusBadge: 'Validado',
                  statusBadgeBg: Colors.green.withOpacity(0.1),
                  statusBadgeColor: Colors.green,
                ),
                const SizedBox(height: 12),
                _buildHistoryCard(
                  title: 'Satélite — Cimentación',
                  subtitle: '10 jun - Concretos Premium',
                  amount: '\$890k',
                  statusBadge: 'Validado',
                  statusBadgeBg: Colors.green.withOpacity(0.1),
                  statusBadgeColor: Colors.green,
                ),
                const SizedBox(height: 12),
                _buildHistoryCard(
                  title: 'C. Comercial Sur — Platea',
                  subtitle: '8 jun - Mat. Reforma',
                  amount: '\$920k',
                  statusBadge: 'Pendiente',
                  statusBadgeBg: Colors.orange.withOpacity(0.1),
                  statusBadgeColor: Colors.orange[800]!,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // Reportes selected
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: 'Proyectos'),
          BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined), label: 'Validar'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reportes'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return Container(
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
