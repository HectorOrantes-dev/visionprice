import 'package:flutter/material.dart';

class ArquitectoProveedoresTecnicosPage extends StatelessWidget {
  const ArquitectoProveedoresTecnicosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            const Text(
              'Vista 6 / 10',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Text(
              'Ferreterías Cercanas',
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
                  child: const Icon(Icons.location_on_outlined, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Proveedores técnicos',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Torre Corp. - Polanco, CDMX',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Especificación', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(child: Text('Precio', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                ),
                const Expanded(
                  child: Center(child: Text('Cercanía', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildStoreCard(
                    title: 'Aceros del Norte Polanco',
                    isStar: true,
                    badgeText: 'Cubre todo',
                    badgeColor: Colors.blue.withOpacity(0.2),
                    badgeTextColor: Colors.blue[700]!,
                    subtitle: '0.5 km · Col. Polanco',
                    borderColor: Colors.blue,
                    items: [
                      _buildListItem('Acero grado 42 Varilla #8', '\$29,400/ton', true),
                      _buildListItem('Concreto f\'c 300 premezclado', '\$2,450/m³', true),
                    ],
                    total: 'Total: \$1,031,600 MXN',
                    buttonColor: Colors.blue[600]!,
                    buttonText: 'Seleccionar',
                    buttonIcon: Icons.check,
                  ),
                  const SizedBox(height: 16),
                  _buildStoreCard(
                    title: 'Concretos Premium CDMX',
                    isStar: false,
                    badgeText: 'Parcial',
                    badgeColor: Colors.orange.withOpacity(0.2),
                    badgeTextColor: Colors.orange[800]!,
                    subtitle: '1.2 km · Cuauhtémoc',
                    borderColor: Colors.grey.withOpacity(0.3),
                    items: [
                      _buildListItem('Acero grado 42 — no disponible', null, false),
                      _buildListItem('Concreto f\'c 300', '\$2,310/m³', true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard({
    required String title,
    required bool isStar,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String subtitle,
    required Color borderColor,
    required List<Widget> items,
    String? total,
    Color? buttonColor,
    String? buttonText,
    IconData? buttonIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isStar) const Icon(Icons.star, color: Colors.amber, size: 20),
              if (isStar) const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(badgeText, style: TextStyle(color: badgeTextColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 12),
          ...items,
          if (total != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(buttonIcon, size: 16, color: Colors.white),
                  label: Text(buttonText!, style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListItem(String name, String? price, bool isAvailable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8, color: isAvailable ? Colors.green : Colors.red),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 13),
                children: [
                  TextSpan(text: name, style: TextStyle(color: isAvailable ? Colors.black87 : Colors.red)),
                  if (price != null) const TextSpan(text: ' · ', style: TextStyle(color: Colors.grey)),
                  if (price != null) TextSpan(text: price, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
