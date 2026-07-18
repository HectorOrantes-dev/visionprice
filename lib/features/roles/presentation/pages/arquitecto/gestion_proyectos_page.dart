import 'package:flutter/material.dart';

class ArquitectoGestionProyectosPage extends StatelessWidget {
  const ArquitectoGestionProyectosPage({super.key});

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
              'Vista 9 / 10',
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
                  child: const Icon(Icons.folder_outlined, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mis proyectos',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '4 activos - Arq. Sánchez',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.blue),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Buscar proyecto...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildProjectCard(
                  title: 'Torre Corporativa Polanco',
                  statusBadge: 'Alerta',
                  statusBadgeBg: Colors.red.withOpacity(0.1),
                  statusBadgeColor: Colors.red,
                  subtitle: 'Polanco · 3 contratistas · 18 partidas',
                  progressValue: 0.8,
                  progressColor: Colors.red,
                  bottomLeftText: '\$1.4M',
                  bottomCenterBadge: 'En validación',
                  bottomCenterBadgeBg: Colors.orange.withOpacity(0.1),
                  bottomCenterBadgeColor: Colors.orange[800]!,
                  bottomRightText: 'Desviación +18%',
                ),
                const SizedBox(height: 16),
                _buildProjectCard(
                  title: 'Residencial Satélite',
                  statusBadge: 'Normal',
                  statusBadgeBg: Colors.green.withOpacity(0.1),
                  statusBadgeColor: Colors.green,
                  subtitle: 'Satélite · 2 contratistas · 11 partidas',
                  progressValue: 0.75,
                  progressColor: Colors.green,
                  bottomLeftText: '\$890k',
                  bottomCenterBadge: 'En obra',
                  bottomCenterBadgeBg: Colors.green.withOpacity(0.1),
                  bottomCenterBadgeColor: Colors.green[800]!,
                  bottomRightText: 'Avance 75%',
                ),
                const SizedBox(height: 16),
                _buildProjectCard(
                  title: 'Centro Comercial Sur',
                  statusBadge: 'Revisión',
                  statusBadgeBg: Colors.orange.withOpacity(0.1),
                  statusBadgeColor: Colors.orange[800]!,
                  subtitle: 'Pedregal · 4 contratistas · 24 partidas',
                  progressValue: 0.4,
                  progressColor: Colors.orange,
                  bottomLeftText: '\$920k',
                  bottomCenterBadge: 'En cotización',
                  bottomCenterBadgeBg: Colors.blue.withOpacity(0.1),
                  bottomCenterBadgeColor: Colors.blue[800]!,
                  bottomRightText: 'Avance 40%',
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
          BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined), label: 'Validar'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reportes'),
        ],
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
