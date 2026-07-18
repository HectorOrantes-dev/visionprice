import 'package:flutter/material.dart';

class IngenieroRevisionParametrosPage extends StatelessWidget {
  const IngenieroRevisionParametrosPage({super.key});

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
              'Vista 5 / 12',
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
                'Ingeniero',
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
                        'Hallazgo detectado',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Torre Corp. P4 - Trabe T-12',
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
                    title: "Acero en trabe T-12 Eje 4",
                    value: "Colocado #6 - Plano indica #8",
                    status: "✕ Sustitución no autorizada · -22% sección",
                    statusColor: Colors.red,
                    borderColor: Colors.orange,
                    iconColor: Colors.orange,
                    iconBgColor: Colors.orange.withOpacity(0.1),
                    valueColor: Colors.orange[800]!,
                  ),
                  const SizedBox(height: 12),
                  _buildParamCard(
                    icon: Icons.location_on_outlined,
                    title: "Ubicación del hallazgo",
                    value: "Piso 4 - Eje D / Eje 4",
                    status: "✓ Confirmado en campo",
                    statusColor: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  _buildParamCard(
                    icon: Icons.person_outline,
                    title: "Responsable cuadrilla",
                    value: "Mtro. Rodríguez - turno matutino",
                    status: "✓ Identificado",
                    statusColor: Colors.grey,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Registrar anomalía', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
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
