import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/recording_provider.dart';

/// Chip que refleja la conectividad REAL (ping al back-end):
/// - verificando → gris neutro
/// - en línea → verde "Conectado"
/// - offline → naranja "Sin internet · audio guardado localmente"
/// Antes el privado `_ConnectivityChip`.
class ConnectivityChip extends StatelessWidget {
  final RecordingViewModel vm;
  const ConnectivityChip({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final online = vm.online;

    late final Color bg;
    late final Color fg;
    late final IconData icon;
    late final String label;

    if (online == null) {
      bg = AppColors.surfaceVariant;
      fg = AppColors.textSecondary;
      icon = Icons.wifi_find_outlined;
      label = 'Verificando conexión...';
    } else if (online) {
      bg = AppColors.successLight;
      fg = AppColors.success;
      icon = Icons.wifi;
      label = 'Conectado · listo para subir';
    } else {
      bg = AppColors.warningLight;
      fg = AppColors.warning;
      icon = Icons.wifi_off;
      label = 'Sin internet · audio guardado localmente';
    }

    return GestureDetector(
      onTap: vm.checkConnectivity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: fg,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
