import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/home_provider.dart';

/// Encabezado del dashboard: logo + saludo con el nombre del usuario y la
/// campana de notificaciones. (Antes el privado `_AppBar`; renombrado para no
/// colisionar con el `AppBar` de Material.)
class DashboardAppBar extends ConsumerWidget {
  const DashboardAppBar({super.key});

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
                  style: AppTextStyles.heading(
                    size: 18,
                    weight: FontWeight.w700,
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
                          color:
                              context.colors.textPrimary.withValues(alpha: 0.8),
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
