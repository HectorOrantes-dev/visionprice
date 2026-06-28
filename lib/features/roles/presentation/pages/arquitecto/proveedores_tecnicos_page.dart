import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ArquitectoProveedoresTecnicosPage extends StatefulWidget {
  const ArquitectoProveedoresTecnicosPage({super.key});

  @override
  State<ArquitectoProveedoresTecnicosPage> createState() => _ArquitectoProveedoresTecnicosPageState();
}

class _ArquitectoProveedoresTecnicosPageState extends State<ArquitectoProveedoresTecnicosPage> {
  String _activeTab = 'Especificación';

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
        title: const Text(
          'Ferreterías Cercanas',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
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
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTab = 'Especificación'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _activeTab == 'Especificación' ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('Especificación', style: TextStyle(color: _activeTab == 'Especificación' ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTab = 'Precio'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _activeTab == 'Precio' ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('Precio', style: TextStyle(color: _activeTab == 'Precio' ? Colors.white : Colors.grey, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTab = 'Cercanía'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _activeTab == 'Cercanía' ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('Cercanía', style: TextStyle(color: _activeTab == 'Cercanía' ? Colors.white : Colors.grey, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
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
              children: [
                Expanded(
                  child: Text(total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(buttonIcon, size: 16, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(buttonText!, style: const TextStyle(color: Colors.white)),
                    ],
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
