import 'package:flutter/material.dart';
import 'proveedores_tecnicos_page.dart';

class ArquitectoParametrosTecnicosPage extends StatelessWidget {
  const ArquitectoParametrosTecnicosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue, size: 20),
          onPressed: () {},
        ),
        title: Column(
          children: [
            const Text(
              'Vista 5 / 10',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Text(
              'Revisión de Parámetros',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.fact_check_outlined, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parámetros técnicos',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Torre Corp. — Estructura P4',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildParamCard(
                    icon: Icons.architecture,
                    title: "Acero grado 42 — trabes y columnas",
                    value: "~8.4 ton estimadas",
                    status: "✓ Alta confianza",
                    statusColor: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  _buildParamCard(
                    icon: Icons.layers_outlined,
                    title: "Concreto f'c 300 — losas de carga",
                    value: "320 m³ estimados",
                    status: "✓ Alta confianza",
                    statusColor: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  _buildParamCard(
                    icon: Icons.view_sidebar_outlined,
                    title: "Castillos — muros de confinamiento",
                    value: "Ancho no especificado",
                    status: "Baja confianza — consultar plano A-03",
                    statusColor: Colors.orange,
                    borderColor: Colors.orange,
                    iconColor: Colors.orange,
                    iconBgColor: Colors.orange.withOpacity(0.1),
                    valueColor: Colors.orange,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ArquitectoProveedoresTecnicosPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Confirmar y buscar proveedores', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParamCard({
    required IconData icon,
    required String title,
    required String value,
    required String status,
    required Color statusColor,
    Color borderColor = const Color(0xFFE0E0E0),
    Color iconColor = Colors.blue,
    Color? iconBgColor,
    Color valueColor = Colors.blue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor ?? Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
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
                Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
