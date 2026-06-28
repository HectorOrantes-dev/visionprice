import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../recording/presentation/screens/recording_screen.dart';

// Fix: use AppRoutes from app_router.dart


class ArquitectoGestionProyectosPage extends StatefulWidget {
  final VoidCallback? onBack;
  const ArquitectoGestionProyectosPage({super.key, this.onBack});

  @override
  State<ArquitectoGestionProyectosPage> createState() => _ArquitectoGestionProyectosPageState();
}

class _ArquitectoGestionProyectosPageState extends State<ArquitectoGestionProyectosPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.blue, size: 20),
                onPressed: widget.onBack,
              )
            : null,
        title: const Text(
          'Gestión de Proyectos',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
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
                  onPressed: () => _showCreateSheet(context),
                  icon: const Icon(Icons.add, color: Colors.blue),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Buscar proyecto...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if ('torre corporativa polanco'.contains(_searchQuery))
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
                if ('torre corporativa polanco'.contains(_searchQuery))
                  const SizedBox(height: 16),
                if ('residencial satélite'.contains(_searchQuery))
                  _buildProjectCard(
                    title: 'Residencial Satélite',
                    statusBadge: 'Normal',
                    statusBadgeBg: Colors.green.withOpacity(0.1),
                    statusBadgeColor: Colors.green,
                    subtitle: 'Satélite · 2 contratistas · 11 partidas',
                    progressValue: 0.45,
                    progressColor: Colors.green,
                    bottomLeftText: '\$850K',
                    bottomCenterBadge: 'Aprobado',
                    bottomCenterBadgeBg: Colors.green.withOpacity(0.1),
                    bottomCenterBadgeColor: Colors.green,
                    bottomRightText: 'En tiempo',
                  ),
                if ('residencial satélite'.contains(_searchQuery))
                  const SizedBox(height: 16),
                if ('plaza comercial cumbres'.contains(_searchQuery))
                  _buildProjectCard(
                    title: 'Plaza Comercial Cumbres',
                    statusBadge: 'Revisión',
                    statusBadgeBg: Colors.orange.withOpacity(0.1),
                    statusBadgeColor: Colors.orange,
                    subtitle: 'Monterrey · 4 contratistas · 24 partidas',
                    progressValue: 0.6,
                    progressColor: Colors.orange,
                    bottomLeftText: '\$2.1M',
                    bottomCenterBadge: 'Cotizando',
                    bottomCenterBadgeBg: Colors.blue.withOpacity(0.1),
                    bottomCenterBadgeColor: Colors.blue,
                    bottomRightText: 'Desviación +5%',
                  ),
                if ('plaza comercial cumbres'.contains(_searchQuery))
                  const SizedBox(height: 16),
                if ('remodelación hospital sur'.contains(_searchQuery))
                  _buildProjectCard(
                    title: 'Remodelación Hospital Sur',
                    statusBadge: 'Normal',
                    statusBadgeBg: Colors.green.withOpacity(0.1),
                    statusBadgeColor: Colors.green,
                    subtitle: 'CDMX Sur · 1 contratista · 5 partidas',
                    progressValue: 0.15,
                    progressColor: Colors.green,
                    bottomLeftText: '\$320K',
                    bottomCenterBadge: 'Planeación',
                    bottomCenterBadgeBg: Colors.grey.withOpacity(0.1),
                    bottomCenterBadgeColor: Colors.grey[700]!,
                    bottomRightText: 'En tiempo',
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nuevo proyecto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Elige cómo deseas crear el proyecto',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 20),
              _SheetOption(
                icon: Icons.mic,
                iconColor: Colors.blue,
                title: 'Nueva cotización por voz',
                subtitle: 'Describe el proyecto con tu micrófono',
                onTap: () {
                  Navigator.pop(context); // Cerrar el bottom sheet
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordingScreen()));
                },
              ),
              const SizedBox(height: 12),
              _SheetOption(
                icon: Icons.edit_note,
                iconColor: Colors.green,
                title: 'Ingresar datos manualmente',
                subtitle: 'Llena el formulario con los detalles',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Formulario manual (próximamente)')),
                  );
                },
              ),
              const SizedBox(height: 12),
              _SheetOption(
                icon: Icons.upload_file_outlined,
                iconColor: Colors.purple,
                title: 'Importar desde archivo',
                subtitle: 'Sube un PDF o Excel con el presupuesto',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Importar archivo (próximamente)')),
                  );
                },
              ),
            ],
          ),
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

// ─── Sheet option widget ──────────────────────────────────────────────────────

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: iconColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: Colors.grey.withOpacity(0.5), size: 20),
          ],
        ),
      ),
    );
  }
}

