import 'package:flutter/material.dart';

class IngenieroAnomaliasTecnicasPage extends StatelessWidget {
  const IngenieroAnomaliasTecnicasPage({super.key});

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
              'Vista 11 / 12',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Text(
              'Panel de Anomalías',
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
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anomalías técnicas',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '5 activas - semana 24',
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
                _buildChip('Alta severidad', isSelected: true, color: Colors.red),
                const SizedBox(width: 8),
                _buildChip('Media'),
                const SizedBox(width: 8),
                _buildChip('Resuelta'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildAnomalyCard(
                  title: 'A-047 - Sustitución de acero no autorizada',
                  titleColor: Colors.red[700]!,
                  badge: 'Alta',
                  badgeBg: Colors.red.withOpacity(0.1),
                  badgeColor: Colors.red,
                  subtitle: 'Torre Polanco P4 · T-12 · hoy 09:18',
                  content: 'Varilla #6 colocada en lugar de #8 (-22% sección). Costo corrección: \$11,760.',
                  borderColor: Colors.red.withOpacity(0.3),
                  showButtons: true,
                ),
                const SizedBox(height: 12),
                _buildAnomalyCard(
                  title: 'A-044 - Impermeabilizante sin certificación',
                  titleColor: Colors.orange[800]!,
                  badge: 'Media',
                  badgeBg: Colors.orange.withOpacity(0.1),
                  badgeColor: Colors.orange[800]!,
                  subtitle: 'Residencial Satélite · azotea · 14 jun',
                  content: 'Material aplicado sin número de lote o certificación del fabricante.',
                  borderColor: Colors.orange.withOpacity(0.3),
                  showButtons: true,
                ),
                const SizedBox(height: 12),
                _buildAnomalyCard(
                  title: 'A-041 - Exceso de agua en mezcla',
                  titleColor: Colors.red[700]!,
                  badge: 'Resuelta',
                  badgeBg: Colors.green.withOpacity(0.1),
                  badgeColor: Colors.green,
                  subtitle: 'Vallejo · losa piso 1 · 10 jun',
                  content: 'Corrección aplicada. Muestras de resistencia dentro de parámetros.',
                  borderColor: Colors.green.withOpacity(0.3),
                  showButtons: false,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Anomalías selected
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

  Widget _buildChip(String label, {bool isSelected = false, Color color = Colors.blue}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? color : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? color : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAnomalyCard({
    required String title,
    required Color titleColor,
    required String badge,
    required Color badgeBg,
    required Color badgeColor,
    required String subtitle,
    required String content,
    required Color borderColor,
    required bool showButtons,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: titleColor)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 14)),
          if (showButtons) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.warning_amber_rounded, color: titleColor, size: 16),
                    label: Text('Escalar', style: TextStyle(color: titleColor)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: titleColor.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Ver detalle', style: TextStyle(color: Colors.black87)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
