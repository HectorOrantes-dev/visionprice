import 'package:flutter/material.dart';
import 'ferreterias_page.dart';

class ContratistaParametrosPage extends StatelessWidget {
  const ContratistaParametrosPage({super.key});

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
        title: const Text(
          'Revisión de Parámetros',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Info
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
                        'Parámetros detectados',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Torre Reforma — Piso 3',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // List of items
            Expanded(
              child: ListView(
                children: [
                  _buildParamCard(
                    icon: Icons.layers_outlined,
                    title: "Losa de concreto f'c 250",
                    value: "200 m² · e=15 cm",
                    status: "✓ Alta confianza",
                    statusColor: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  _buildParamCard(
                    icon: Icons.architecture,
                    title: "Acero de refuerzo #4",
                    value: "180 kg estimados",
                    status: "✓ Alta confianza",
                    statusColor: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  _buildParamCard(
                    icon: Icons.water_drop_outlined,
                    title: "Impermeabilizante",
                    value: "~200 m² - tipo no especificado",
                    status: "Baja confianza — confirma el tipo",
                    statusColor: Colors.orange,
                    borderColor: Colors.orange,
                    iconColor: Colors.orange,
                    iconBgColor: Colors.orange.withOpacity(0.1),
                    valueColor: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildParamCard(
                    icon: Icons.lens_blur,
                    title: "Drenajes PVC",
                    value: "Cantidad por definir",
                    status: "⚠ Revisar cantidad",
                    statusColor: Colors.orange,
                    valueColor: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  
                  // Agregar partida button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20, color: Colors.black87),
                        SizedBox(width: 8),
                        Text('Agregar partida', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContratistaFerreteriasPage()),
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
                    Text('Confirmar y calcular', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
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
