import 'package:flutter/material.dart';

class IngenieroProcesandoHallazgoPage extends StatelessWidget {
  const IngenieroProcesandoHallazgoPage({super.key});

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
              'Vista 4 / 12',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Text(
              'Procesando (LLM)',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.settings_suggest, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Procesando hallazgo',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Torre Corp. P4 - auditoría',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('TRANSCRIPCIÓN DEL HALLAZGO', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: const Text(
                '"El acero colocado en la trabe T-12 del eje cuatro tiene diámetro número seis, pero el plano estructural indica número ocho. La diferencia es de un veintidós por ciento en sección transversal."',
                style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 24),
            const Text('CLASIFICANDO ANOMALÍA', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  _buildStep(Icons.check_circle, Colors.green, 'Transcribiendo hallazgo', '0:33 procesados'),
                  const Divider(height: 32),
                  _buildStep(Icons.check_circle, Colors.green, 'Detectando tipo de anomalía', 'Sustitución de material - severidad alta'),
                  const Divider(height: 32),
                  _buildStep(Icons.shield_outlined, Colors.blue, 'Generando alerta técnica', 'Notificando a Arq. supervisor...', isLast: true, showSpinner: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(IconData icon, Color color, String title, String subtitle, {bool isLast = false, bool showSpinner = false}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: showSpinner ? Colors.blue : Colors.black)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        if (showSpinner)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }
}
