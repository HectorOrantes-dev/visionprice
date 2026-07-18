import 'package:flutter/material.dart';

class IngenieroProyectosAuditadosPage extends StatelessWidget {
  const IngenieroProyectosAuditadosPage({super.key});

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
              'Vista 9 / 12',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Text(
              'Gestión de Proyectos',
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
                  child: const Icon(Icons.folder_outlined, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Proyectos auditados',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Ing. Flores - acceso completo',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildChip('Todos', isSelected: true),
                const SizedBox(width: 8),
                _buildChip('Con anomalías'),
                const SizedBox(width: 8),
                _buildChip('Aprobados'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildProjectCard(
                  title: 'Torre Corporativa Polanco',
                  statusBadge: '5 anomalías',
                  statusBadgeBg: Colors.red.withOpacity(0.1),
                  statusBadgeColor: Colors.red,
                  subtitle: '3 contratistas · 18 partidas · auditoría activa',
                  progressValue: 0.8,
                  progressColor: Colors.red,
                  bottomLeftText: '\$1.4M',
                  bottomCenterBadge: 'Alerta técnica',
                  bottomCenterBadgeBg: Colors.red.withOpacity(0.1),
                  bottomCenterBadgeColor: Colors.red,
                  bottomRightText: 'Hallazgo A-047',
                ),
                const SizedBox(height: 16),
                _buildProjectCard(
                  title: 'Bodega Industrial Vallejo',
                  statusBadge: 'Aprobado',
                  statusBadgeBg: Colors.green.withOpacity(0.1),
                  statusBadgeColor: Colors.green,
                  subtitle: '1 contratista · 5 partidas · auditado',
                  progressValue: 1.0,
                  progressColor: Colors.green,
                  bottomLeftText: '\$148,900',
                  bottomCenterBadge: 'Sin observaciones',
                  bottomCenterBadgeBg: Colors.green.withOpacity(0.1),
                  bottomCenterBadgeColor: Colors.green,
                  bottomRightText: '10 jun',
                ),
                const SizedBox(height: 16),
                _buildProjectCard(
                  title: 'Residencial Satélite',
                  statusBadge: 'En revisión',
                  statusBadgeBg: Colors.orange.withOpacity(0.1),
                  statusBadgeColor: Colors.orange[800]!,
                  subtitle: '2 contratistas · 11 partidas',
                  progressValue: 0.6,
                  progressColor: Colors.orange,
                  bottomLeftText: '\$890k',
                  bottomCenterBadge: '2 observaciones',
                  bottomCenterBadgeBg: Colors.orange.withOpacity(0.1),
                  bottomCenterBadgeColor: Colors.orange[800]!,
                  bottomRightText: 'Pendiente',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Proyectos selected
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Proyectos'),
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

  Widget _buildProjectCard({
    required String title,
    required String statusBadge,
    required Color statusBadgeBg,
    required Color statusBadgeColor,
    required String subtitle,
    required double progressValue,
    required Color progressColor,
    required String bottomLeftText,
    required String bottomCenterBadge,
    required Color bottomCenterBadgeBg,
    required Color bottomCenterBadgeColor,
    required String bottomRightText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBadgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(statusBadge, style: TextStyle(color: statusBadgeColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey[200],
            color: progressColor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(bottomLeftText, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bottomCenterBadgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(bottomCenterBadge, style: TextStyle(color: bottomCenterBadgeColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              Text(bottomRightText, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
