import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../account/presentation/screens/subscriptions_screen.dart';
import '../../../auth/presentation/providers/perfil_provider.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../recommendations/presentation/screens/entrenar_modelos_screen.dart';
import '../../../security/presentation/screens/sensitive_data_screen.dart';
import 'perfil_error.dart';
import 'perfil_info_card.dart';
import 'profile_item.dart';

/// Pestaña "Perfil": datos de la cuenta (`AsyncValue<PerfilEntity>`) + accesos a
/// suscripciones, notificaciones, datos sensibles y cerrar sesión.
class PerfilTab extends ConsumerWidget {
  final VoidCallback onLogout;

  const PerfilTab({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // El perfil llega como AsyncValue<PerfilEntity> desde perfilProvider.
    final perfilAsync = ref.watch(perfilProvider);
    final perfil = perfilAsync.asData?.value;
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
                  : (perfilAsync.isLoading ? 'Cargando…' : 'Mi perfil'),
              style: AppTextStyles.heading(
                size: 18,
                weight: FontWeight.w700,
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
          perfilAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => PerfilError(
              message: e is ApiException
                  ? e.message
                  : 'No se pudo cargar el perfil',
              onRetry: () => ref.invalidate(perfilProvider),
            ),
            data: (p) => PerfilInfoCard(perfil: p),
          ),
          const SizedBox(height: 20),
          ProfileItem(
            icon: Icons.workspace_premium_outlined,
            label: 'Mis suscripciones',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubscriptionsScreen()),
            ),
          ),
          const SizedBox(height: 10),
          ProfileItem(
            icon: Icons.notifications_none,
            label: 'Notificaciones',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          const SizedBox(height: 10),
          ProfileItem(
            icon: Icons.shield_outlined,
            label: 'Datos sensibles',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SensitiveDataScreen()),
            ),
          ),
          // Entrenar los modelos de recomendación: el back-end solo lo permite
          // al rol `ingeniero_civil`, así que solo a él se le muestra la opción.
          if (perfil?.rol == 'ingeniero_civil') ...[
            const SizedBox(height: 10),
            ProfileItem(
              icon: Icons.model_training_outlined,
              label: 'Entrenar modelos',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EntrenarModelosScreen()),
              ),
            ),
          ],
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
  }
}
