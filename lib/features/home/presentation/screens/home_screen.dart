import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../recording/presentation/screens/recording_screen.dart';
import '../../../sync/presentation/screens/sync_queue_screen.dart';
import '../../../budget/presentation/screens/budget_result_screen.dart';
import '../../../security/presentation/screens/inactivity_detector.dart';
import '../../../security/presentation/screens/sensitive_data_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/providers/login_provider.dart';

// Import the specific views for each role
import '../../../roles/presentation/pages/arquitecto/gestion_proyectos_page.dart';
import '../../../roles/presentation/pages/arquitecto/historial_presupuestos_page.dart';
import '../../../roles/presentation/pages/ingeniero/anomalias_tecnicas_page.dart';
import '../../../roles/presentation/pages/ingeniero/proyectos_auditados_page.dart';
import '../../../roles/presentation/pages/ingeniero/historial_auditoria_page.dart';
import '../../../roles/presentation/pages/ingeniero/control_acceso_page.dart';
import '../../../roles/presentation/pages/ingeniero/procesando_hallazgo_page.dart';
import '../../../roles/presentation/pages/ingeniero/revision_parametros_page.dart';
import '../../../roles/presentation/pages/ingeniero/proveedores_verificados_page.dart';
import '../../../roles/presentation/pages/ingeniero/costo_correccion_page.dart';
import '../../../roles/presentation/pages/ingeniero/reporte_auditoria_page.dart';
import '../../../roles/presentation/pages/arquitecto/parametros_tecnicos_page.dart';
import '../../../roles/presentation/pages/contratista/cuadrilla_page.dart';
import '../../../projects/presentation/pages/home_page.dart' as projects;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  /// Cierra la sesión y regresa al login limpiando la pila de navegación.
  void _logout({String? reason}) {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
    if (reason != null) {
      messenger.showSnackBar(SnackBar(content: Text(reason)));
    }
  }

  List<Widget> _getPagesForRole(String role) {
    if (role == 'arquitecto') {
      return [
        projects.HomePage(
          onProjectsTap: () => setState(() => _currentIndex = 1),
          onReportsTap: () => setState(() => _currentIndex = 3),
        ), // Inicio
        ArquitectoGestionProyectosPage(onBack: () => setState(() => _currentIndex = 0)), // Proyectos
        ArquitectoParametrosTecnicosPage(onBack: () => setState(() => _currentIndex = 0)), // Validar
        ArquitectoHistorialPresupuestosPage(onBack: () => setState(() => _currentIndex = 0)), // Reportes
        _PerfilTab(onLogout: () => _logout()), // Perfil
      ];
    } else if (role == 'ingeniero_civil') {
      return [
        const _IngenieroAuditoriaTab(), // 0 - Inicio (Auditoría)
        IngenieroProyectosAuditadosPage(onBack: () => setState(() => _currentIndex = 0)), // 1 - Proyectos
        IngenieroAnomaliasTecnicasPage(onBack: () => setState(() => _currentIndex = 0)),  // 2 - Anomalías
        IngenieroControlAccesoPage(onBack: () => setState(() => _currentIndex = 0)),      // 3 - RBAC
        IngenieroHistorialAuditoriaPage(onBack: () => setState(() => _currentIndex = 0)), // 4 - Historial
        _PerfilTab(onLogout: () => _logout()), // Perfil
      ];
    } else if (role == 'contratista') {
      return [
        projects.HomePage(
          onProjectsTap: () => setState(() => _currentIndex = 1),
        ), // Inicio
        ArquitectoGestionProyectosPage(onBack: () => setState(() => _currentIndex = 0)), // Proyectos
        ContratistaCuadrillaPage(onBack: () => setState(() => _currentIndex = 0)), // Cuadrilla
        ArquitectoHistorialPresupuestosPage(onBack: () => setState(() => _currentIndex = 0)), // Historial
        _PerfilTab(onLogout: () => _logout()), // Perfil
      ];
    } else {
      // Maestro de Obra
      return [
        const _DashboardTab(),
        projects.HomePage(
          onProjectsTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Viendo proyectos activos')),
            );
          },
        ),
        const SyncQueueScreen(),
        _PerfilTab(onLogout: () => _logout()),
      ];
    }
  }

  List<BottomNavigationBarItem> _getNavItemsForRole(String role) {
    if (role == 'arquitecto') {
      return [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        const BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), activeIcon: Icon(Icons.folder), label: 'Proyectos'),
        const BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined), activeIcon: Icon(Icons.fact_check), label: 'Validar'),
        const BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Reportes'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
      ];
    } else if (role == 'contratista') {
      return [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        const BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), activeIcon: Icon(Icons.folder), label: 'Proyectos'),
        const BottomNavigationBarItem(icon: Icon(Icons.group_outlined), activeIcon: Icon(Icons.group), label: 'Cuadrilla'),
        const BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'Historial'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
      ];
    } else if (role == 'ingeniero_civil') {
      return [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        const BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), activeIcon: Icon(Icons.folder), label: 'Proyectos'),
        const BottomNavigationBarItem(icon: Icon(Icons.warning_amber_outlined), activeIcon: Icon(Icons.warning), label: 'Anomalías'),
        const BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), activeIcon: Icon(Icons.shield), label: 'RBAC'),
        const BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'Historial'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
      ];
    } else {
      // Maestro de Obra
      return [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        const BottomNavigationBarItem(icon: Icon(Icons.description_outlined), activeIcon: Icon(Icons.description), label: 'Mis Obras'),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.sync_outlined),
              Positioned(
                right: 0, top: 0,
                child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
              ),
            ],
          ),
          activeIcon: const Icon(Icons.sync), label: 'Sync',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
      ];
    }
  }

  Widget? _buildDrawer(String role) {
    if (role == 'contratista' || role == 'arquitecto') {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Text('Menú ${role.toUpperCase()}', style: const TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mi Perfil'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else if (role == 'ingeniero_civil') {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text('Menú Ingeniero', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.shield),
              title: const Text('Control RBAC'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<LoginViewModel>().currentUserRole;
    final pages = _getPagesForRole(role);
    final navItems = _getNavItemsForRole(role);
    
    // Safety check in case of changing roles
    if (_currentIndex >= pages.length) {
      _currentIndex = 0;
    }

    return InactivityDetector(
      onTimeout: () => _logout(reason: 'Sesión cerrada por inactividad.'),
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: _buildDrawer(role),
        body: pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          items: navItems,
        ),
      ),
    );
  }
}

// ─── Dashboard Tab ───────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AppBar(),
                _OfflineBanner(),
                const SizedBox(height: 16),
                _newBudgetButton(context),
                const SizedBox(height: 12),
                _PendingSyncChip(),
                const SizedBox(height: 24),
                _SectionTitle('PRESUPUESTOS RECIENTES'),
                const SizedBox(height: 8),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _BudgetItem(
                  icon: Icons.description_outlined,
                  title: 'Remodelación Cocina',
                  subtitle: 'Col. Del Valle · hace 2 h',
                  status: 'En proceso',
                  statusColor: AppColors.warning,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetResultScreen())),
                ),
                const SizedBox(height: 8),
                _BudgetItem(
                  icon: Icons.description_outlined,
                  title: 'Ampliación Cuarto',
                  subtitle: 'Iztapalapa · ayer',
                  status: 'Borrador',
                  statusColor: AppColors.textSecondary,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abriendo borrador...')),
                  ),
                ),
                const SizedBox(height: 8),
                _BudgetItem(
                  icon: Icons.description_outlined,
                  title: 'Bardeo Perimetral',
                  subtitle: 'Xochimilco · hace 3 días',
                  status: 'Completado',
                  statusColor: AppColors.success,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetResultScreen())),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.home_outlined,
                  color: AppColors.primary, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VisionPrice',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Buenos días, Roberto 👋',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.notifications_outlined,
              color: AppColors.textSecondary, size: 24),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off, size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Text(
            'Sin conexión — los audios se guardan localmente',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.warning,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _newBudgetButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordingScreen())),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 20),
            SizedBox(width: 10),
            Text('Nuevo presupuesto por voz'),
          ],
        ),
      ),
    ),
  );
}

class _PendingSyncChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_upload_outlined,
                size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
                children: [
                  TextSpan(
                    text: '2 audios',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(text: ' pendientes de sincronizar'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _BudgetItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap;

  const _BudgetItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Placeholder tabs ────────────────────────────────────────────────────────

class _MisObrasTab extends StatelessWidget {
  const _MisObrasTab();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'Mis Obras',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _PerfilTab extends StatelessWidget {
  final VoidCallback onLogout;

  const _PerfilTab({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primaryLight,
              child: const Icon(Icons.person,
                  size: 40, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Roberto Maestro',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Center(
            child: Text(
              'miguel.angel@obra.mx',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 28),
          _ProfileItem(
            icon: Icons.shield_outlined,
            label: 'Datos sensibles',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SensitiveDataScreen()),
            ),
          ),
          const SizedBox(height: 10),
          _ProfileItem(
            icon: Icons.logout,
            label: 'Cerrar sesión',
            danger: true,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: color),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, size: 20, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

// ─── Ingeniero Civil Dashboard Tab ───────────────────────────────────────────

class _IngenieroAuditoriaTab extends StatelessWidget {
  const _IngenieroAuditoriaTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.shield,
                            color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'VisionPrice Ingeniería',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Hola, Ing. Flores 🔬',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(Icons.notifications_outlined,
                          color: AppColors.textSecondary, size: 24),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: _AuditStatCard(
                          label: 'Proyectos auditados',
                          value: '12',
                          icon: Icons.business_center,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AuditStatCard(
                          label: 'Anomalías activas',
                          value: '3',
                          icon: Icons.warning_amber_rounded,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _AuditStatCard(
                          label: 'Reportes este mes',
                          value: '8',
                          icon: Icons.description_outlined,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AuditStatCard(
                          label: 'Sin procesar',
                          value: '2',
                          icon: Icons.pending_outlined,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botón principal — Nueva Auditoría por grabación
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RecordingScreen()),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mic, size: 20),
                          SizedBox(width: 10),
                          Text('Nueva auditoría por voz'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Flujo de auditoría — accesos directos
                  const Text(
                    'FLUJO DE AUDITORÍA',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _AuditFlowItem(
                    icon: Icons.settings_outlined,
                    title: 'Procesando hallazgo',
                    subtitle: 'LLM analizando descripción de anomalía',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const _ProcessingPlaceholderIng()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _AuditFlowItem(
                    icon: Icons.edit_note_outlined,
                    title: 'Revisión de parámetros',
                    subtitle: 'Confirma los datos detectados',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const _RevisionPlaceholderIng()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _AuditFlowItem(
                    icon: Icons.store_outlined,
                    title: 'Proveedores verificados',
                    subtitle: 'Ferreterías con stock validado',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const _ProveedoresPlaceholderIng()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _AuditFlowItem(
                    icon: Icons.calculate_outlined,
                    title: 'Costo de corrección',
                    subtitle: 'Presupuesto de corrección estimado',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const _CostoPlaceholderIng()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _AuditFlowItem(
                    icon: Icons.summarize_outlined,
                    title: 'Reporte de auditoría',
                    subtitle: 'Genera y exporta el reporte final',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const _ReportePlaceholderIng()),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Placeholders del flujo Ingeniero (páginas específicas) ──────────────────

class _ProcessingPlaceholderIng extends StatelessWidget {
  const _ProcessingPlaceholderIng();
  @override
  Widget build(BuildContext context) {
    return const IngenieroProcesandoHallazgoPage();
  }
}

class _RevisionPlaceholderIng extends StatelessWidget {
  const _RevisionPlaceholderIng();
  @override
  Widget build(BuildContext context) {
    return const IngenieroRevisionParametrosPage();
  }
}

class _ProveedoresPlaceholderIng extends StatelessWidget {
  const _ProveedoresPlaceholderIng();
  @override
  Widget build(BuildContext context) {
    return const IngenieroProveedoresVerificadosPage();
  }
}

class _CostoPlaceholderIng extends StatelessWidget {
  const _CostoPlaceholderIng();
  @override
  Widget build(BuildContext context) {
    return const IngenieroCostoCorreccionPage();
  }
}

class _ReportePlaceholderIng extends StatelessWidget {
  const _ReportePlaceholderIng();
  @override
  Widget build(BuildContext context) {
    return const IngenieroReporteAuditoriaPage();
  }
}

class _IngenieroFlowWrapper extends StatelessWidget {
  final Widget child;
  const _IngenieroFlowWrapper({required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: child,
    );
  }
}

// ─── Widgets auxiliares del Ingeniero Dashboard ───────────────────────────────

class _AuditStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _AuditStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditFlowItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AuditFlowItem({
    required this.icon,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
