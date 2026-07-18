import 'package:flutter/material.dart';

class IngenieroControlAccesoPage extends StatelessWidget {
  const IngenieroControlAccesoPage({super.key});

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
              'Vista 12 / 12',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Text(
              'Control RBAC',
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
                  child: const Icon(Icons.security, color: Colors.blue),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Control de acceso',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '14 usuarios · 3 proyectos',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add_alt_1, color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Usuarios', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(child: Text('Roles', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                ),
                const Expanded(
                  child: Center(child: Text('Permisos', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildUserItem(
                  initials: 'IM',
                  avatarColor: Colors.blue,
                  name: 'Ing. Martínez',
                  role: 'Contratista · Torre Polanco, Satélite',
                  status: 'Activo',
                  statusColor: Colors.green,
                  permissions: 'Cotizar · Ver',
                ),
                const Divider(),
                _buildUserItem(
                  initials: 'AS',
                  avatarColor: Colors.grey[700]!,
                  name: 'Arq. Sánchez',
                  role: 'Arquitecto · todos los proyectos',
                  status: 'Activo',
                  statusColor: Colors.green,
                  permissions: 'Validar · Exportar · Admin',
                ),
                const Divider(),
                _buildUserItem(
                  initials: 'JR',
                  avatarColor: Colors.grey[700]!,
                  name: 'José Ramírez',
                  role: 'Maestro de obra · Torre Polanco',
                  status: 'Activo',
                  statusColor: Colors.green,
                  permissions: 'Grabar · Ver propio',
                ),
                const Divider(),
                _buildUserItem(
                  initials: 'IP',
                  avatarColor: Colors.grey[700]!,
                  name: 'Ing. Pérez',
                  role: 'Contratista · Vallejo (nuevo)',
                  status: 'Invitado',
                  statusColor: Colors.orange[800]!,
                  permissions: 'Pendiente activación',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Invitar usuario', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // RBAC selected
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

  Widget _buildUserItem({
    required String initials,
    required Color avatarColor,
    required String name,
    required String role,
    required String status,
    required Color statusColor,
    required String permissions,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: avatarColor,
            radius: 20,
            child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(role, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              Text(permissions, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
