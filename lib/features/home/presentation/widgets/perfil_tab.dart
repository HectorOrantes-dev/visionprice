import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../account/presentation/screens/subscriptions_screen.dart';
import '../../../auth/presentation/providers/perfil_provider.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../security/presentation/screens/sensitive_data_screen.dart';
import 'perfil_error.dart';
import 'perfil_info_card.dart';
import 'profile_item.dart';

/// Pestaña de Perfil. Carga el perfil desde `/me/perfil` vía [PerfilViewModel].
/// Antes el privado `_PerfilTab`.
class PerfilTab extends StatelessWidget {
  final VoidCallback onLogout;

  const PerfilTab({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<PerfilViewModel>(),
      child: Consumer<PerfilViewModel>(
        builder: (context, vm, _) {
          final perfil = vm.perfil;
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
                Center(
                  child: Text(
                    perfil?.nombre.isNotEmpty == true
                        ? perfil!.nombre
                        : (vm.isLoading ? 'Cargando…' : 'Mi perfil'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (perfil?.correo.isNotEmpty == true)
                  Center(
                    child: Text(
                      perfil!.correo,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ),
                const SizedBox(height: 28),
                if (vm.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (vm.state == PerfilState.error)
                  PerfilError(
                    message: vm.errorMessage ?? 'No se pudo cargar el perfil',
                    onRetry: vm.load,
                  )
                else if (perfil != null)
                  PerfilInfoCard(perfil: perfil),
                const SizedBox(height: 20),
                ProfileItem(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Mis suscripciones',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SubscriptionsScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                ProfileItem(
                  icon: Icons.notifications_none,
                  label: 'Notificaciones',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                ProfileItem(
                  icon: Icons.shield_outlined,
                  label: 'Datos sensibles',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SensitiveDataScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                ProfileItem(
                  icon: Icons.logout,
                  label: 'Cerrar sesión',
                  danger: true,
                  onTap: onLogout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
