import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../devices/data/providers/device_providers.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../recording/presentation/screens/recording_screen.dart';
import '../../../sync/presentation/screens/sync_queue_screen.dart';
import '../../../security/presentation/screens/inactivity_detector.dart';
import '../../../security/presentation/screens/sensitive_data_screen.dart';
import '../../../auth/domain/entities/perfil_entity.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/perfil_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../account/presentation/screens/subscriptions_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../project/domain/entities/proyecto_entity.dart';
import '../providers/home_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    await Permission.location.request();
  }

  final List<Widget> _pages = const [
    _DashboardTab(),
    _MisObrasTab(),
    SyncQueueScreen(),
    SizedBox.shrink(), // index 3 (Perfil) se construye con onLogout en build()
  ];

  /// Cierra la sesión y regresa al login limpiando la pila de navegación.
  void _logout({String? reason}) {
    final messenger = ScaffoldMessenger.of(context);
    // Borra el device token de push y limpia la sesión (token + caché perfil).
    // Se hace en orden: unregister primero (necesita el JWT) y luego logout.
    final deviceRegistrar = ref.read(deviceRegistrarProvider);
    final logoutUseCase = ref.read(logoutUseCaseProvider);
    () async {
      await deviceRegistrar.unregister();
      await logoutUseCase.call();
    }();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
    if (reason != null) {
      messenger.showSnackBar(SnackBar(content: Text(reason)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Toda la zona autenticada queda protegida por el detector de inactividad.
    return InactivityDetector(
      onTimeout: () => _logout(reason: 'Sesión cerrada por inactividad.'),
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: _currentIndex == 3
            ? _PerfilTab(onLogout: () => _logout())
            : _pages[_currentIndex],
        bottomNavigationBar: _BottomNav(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.description_outlined),
          selectedIcon: Icon(Icons.description),
          label: 'Mis Obras',
        ),
        NavigationDestination(
          // Badge de M3: punto rojo indicando audios en cola por sincronizar.
          icon: Badge(
            backgroundColor: context.colors.error,
            smallSize: 8,
            child: Icon(Icons.sync_outlined),
          ),
          selectedIcon: Icon(Icons.sync),
          label: 'Sync',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}

// ─── Dashboard Tab ───────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    // El estado del Dashboard vive en `homeProvider` (Riverpod): carga proyectos
    // y conectividad real al observarse.
    return const _DashboardView();
  }
}

class _DashboardView extends ConsumerWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AppBar(),
                  // Banner de conectividad REAL: solo aparece si estás offline.
                  if (vm.isOffline) _OfflineBanner(),
                  const SizedBox(height: 16),
                  _newBudgetButton(context),
                  const SizedBox(height: 12),
                  _createProjectButton(context, notifier),
                  const SizedBox(height: 24),
                  _SectionTitle('MIS PROYECTOS'),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            _ProjectsSliver(state: vm, notifier: notifier),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

/// Lista de proyectos del usuario (desde el back-end) con sus estados de
/// carga / error / vacío.
class _ProjectsSliver extends StatelessWidget {
  final HomeState state;
  final Home notifier;
  const _ProjectsSliver({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final vm = state;
    if (vm.error != null && vm.proyectos.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                vm.error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: context.colors.textSecondary),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: notifier.cargarProyectos,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.proyectos.isEmpty) {
      return const SliverToBoxAdapter(child: _EmptyProjects());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.separated(
        itemCount: vm.proyectos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _ProjectCard(proyecto: vm.proyectos[i]),
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Icon(Icons.folder_open_outlined,
              size: 40, color: context.colors.textHint),
          const SizedBox(height: 12),
          Text(
            'Aún no tienes proyectos',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Crea tu primer proyecto con el botón de arriba para empezar a grabar presupuestos.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeProvider);
    final nombre = vm.nombreCorto;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(Icons.home_outlined, color: context.colors.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VisionPrice',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: context.colors.textSecondary,
                    ),
                    children: [
                      TextSpan(text: '${vm.saludo}, '),
                      TextSpan(
                        text: nombre != null ? '$nombre 👋' : '👋',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            children: [
              Icon(Icons.notifications_outlined,
                  color: context.colors.textSecondary, size: 26),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: context.colors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.warningLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, size: 18, color: context.colors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sin conexión — los audios se guardan localmente',
              style: TextStyle(
                fontSize: 13,
                color: context.colors.warning,
                fontWeight: FontWeight.w600,
              ),
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
      height: 56,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecordingScreen()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          shadowColor: context.colors.primary.withValues(alpha: 0.4),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic_rounded, size: 22, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Nuevo presupuesto por voz',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Botón de la home para crear un proyecto (el alta ahora vive aquí, no en la
/// pantalla de grabación).
Widget _createProjectButton(BuildContext context, Home notifier) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => showCreateProjectSheet(context, notifier),
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colors.primary,
          side: BorderSide(color: context.colors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.create_new_folder_outlined, size: 20),
            SizedBox(width: 10),
            Text(
              'Crear nuevo proyecto',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Bottom sheet para dar de alta un proyecto desde la home.
void showCreateProjectSheet(BuildContext context, Home notifier) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _CreateProjectSheet(notifier: notifier),
  );
}

class _CreateProjectSheet extends StatefulWidget {
  final Home notifier;
  const _CreateProjectSheet({required this.notifier});

  @override
  State<_CreateProjectSheet> createState() => _CreateProjectSheetState();
}

class _CreateProjectSheetState extends State<_CreateProjectSheet> {
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  bool _creating = false;
  String? _error;

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _crear() async {
    final nombre = _nombreController.text.trim();
    if (nombre.length < 2) {
      setState(() => _error = 'Escribe un nombre (mín. 2 caracteres)');
      return;
    }
    setState(() {
      _creating = true;
      _error = null;
    });
    try {
      await widget.notifier.crearProyecto(
        nombre: nombre,
        direccion: _direccionController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      setState(() => _error = 'No se pudo crear el proyecto.');
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nuevo proyecto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombreController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Nombre',
              hintText: 'Ej. Casa Polanco',
              prefixIcon: Icon(Icons.create_new_folder_outlined,
                  size: 20, color: context.colors.textSecondary),
              errorText: _error,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _direccionController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Dirección (opcional)',
              hintText: 'Ej. Col. Del Valle',
              prefixIcon: Icon(Icons.location_on_outlined,
                  size: 20, color: context.colors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _creating ? null : _crear,
              child: _creating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Crear proyecto'),
            ),
          ),
        ],
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
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: context.colors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

/// Tarjeta de un proyecto real del usuario.
class _ProjectCard extends StatelessWidget {
  final ProyectoEntity proyecto;
  const _ProjectCard({required this.proyecto});

  @override
  Widget build(BuildContext context) {
    final estadoColor = _estadoColor(context, proyecto.estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.folder_outlined,
                size: 18, color: context.colors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proyecto.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: estadoColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _capitalize(proyecto.estado),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: estadoColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _subtitle() {
    final dir = proyecto.direccion;
    final presupuestos = proyecto.totalPresupuestos == 1
        ? '1 presupuesto'
        : '${proyecto.totalPresupuestos} presupuestos';
    if (dir != null && dir.isNotEmpty) return '$dir · $presupuestos';
    return presupuestos;
  }

  static Color _estadoColor(BuildContext context, String estado) {
    switch (estado.toLowerCase()) {
      case 'completado':
      case 'terminado':
        return context.colors.success;
      case 'borrador':
      case 'pausado':
        return context.colors.textSecondary;
      default:
        return context.colors.primary; // activo / en proceso
    }
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
// ─── Placeholder tabs ────────────────────────────────────────────────────────

class _MisObrasTab extends StatelessWidget {
  const _MisObrasTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          'Mis Obras',
          style: TextStyle(
            fontSize: 18,
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _PerfilTab extends ConsumerWidget {
  final VoidCallback onLogout;

  const _PerfilTab({required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // El perfil se carga desde `GET /api/v1/me/perfil` a través de perfilProvider.
    final vm = ref.watch(perfilProvider);
    final notifier = ref.read(perfilProvider.notifier);
    final perfil = vm.perfil;
    return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),
                Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: context.colors.primaryLight,
                    child: Icon(Icons.person,
                        size: 40, color: context.colors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    perfil?.nombre.isNotEmpty == true
                        ? perfil!.nombre
                        : (vm.isLoading ? 'Cargando…' : 'Mi perfil'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                if (perfil?.correo.isNotEmpty == true)
                  Center(
                    child: Text(
                      perfil!.correo,
                      style: TextStyle(
                          fontSize: 13, color: context.colors.textSecondary),
                    ),
                  ),
                const SizedBox(height: 28),
                if (vm.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (vm.status == PerfilStatus.error)
                  _PerfilError(
                    message: vm.errorMessage ?? 'No se pudo cargar el perfil',
                    onRetry: notifier.load,
                  )
                else if (perfil != null)
                  _PerfilInfoCard(perfil: perfil),
                const SizedBox(height: 20),
                _ProfileItem(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Mis suscripciones',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SubscriptionsScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                _ProfileItem(
                  icon: Icons.notifications_none,
                  label: 'Notificaciones',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                _ProfileItem(
                  icon: Icons.shield_outlined,
                  label: 'Datos sensibles',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SensitiveDataScreen()),
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

/// Tarjeta con los datos de la cuenta que devuelve `/me/perfil`.
class _PerfilInfoCard extends StatelessWidget {
  final PerfilEntity perfil;

  const _PerfilInfoCard({required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.badge_outlined,
            label: 'Rol',
            value: _capitalize(perfil.rol.replaceAll('_', ' ')),
          ),
          if (perfil.telefono.isNotEmpty)
            _InfoRow(
              icon: Icons.phone_outlined,
              label: 'Teléfono',
              value: perfil.telefono,
            ),
          _InfoRow(
            icon: Icons.workspace_premium_outlined,
            label: 'Plan',
            value: perfil.tienePlan ? perfil.planActivo! : 'Sin plan activo',
            valueColor:
                perfil.tienePlan ? context.colors.primary : context.colors.textSecondary,
          ),
          if (perfil.vigenciaHasta != null)
            _InfoRow(
              icon: Icons.event_available_outlined,
              label: 'Vigencia',
              value: _fmtDate(perfil.vigenciaHasta!),
            ),
          _InfoRow(
            icon: Icons.lock_outline,
            label: 'Inicio de sesión',
            value: perfil.proveedorAuth == 'google'
                ? 'Google'
                : 'Correo y contraseña',
          ),
          if (perfil.fechaRegistro != null)
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Miembro desde',
              value: _fmtDate(perfil.fechaRegistro!),
              showDivider: false,
            ),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool showDivider;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 18, color: context.colors.textSecondary),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                    fontSize: 13, color: context.colors.textSecondary),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? context.colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: context.colors.border.withValues(alpha: 0.6)),
      ],
    );
  }
}

class _PerfilError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PerfilError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.errorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: context.colors.error),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
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
    final color = danger ? context.colors.error : context.colors.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
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
            Icon(Icons.chevron_right, size: 20, color: context.colors.textHint),
          ],
        ),
      ),
    );
  }
}
