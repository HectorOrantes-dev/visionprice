import 'package:flutter/material.dart';

class IngenieroHistorialAuditoriaPage extends StatelessWidget {
  const IngenieroHistorialAuditoriaPage({super.key});

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
              'Vista 10 / 12',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Text(
              'Historial de auditoría',
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
                'Ingeniero',
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
                _buildChip('Todas', isSelected: true),
                const SizedBox(width: 8),
                _buildChip('Con anomalía'),
                const SizedBox(width: 8),
                _buildChip('Aprobados'),
                const SizedBox(width: 8),
                _buildChip('Junio'),
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
                  subtitle: 'Hoy - hallazgo A-047 - acero sustitución',
                  amount: '\$1.03M',
                  statusBadge: 'Anomalía',
                  statusBadgeBg: Colors.red.withOpacity(0.1),
                  statusBadgeColor: Colors.red,
                  icon: Icons.description_outlined,
                  iconColor: Colors.red[300]!,
                  iconBgColor: Colors.red.withOpacity(0.1),
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4, // Historial selected
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: 'Proyectos'),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'Anomalías'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'RBAC'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
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
