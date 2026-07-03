import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/sync_app_bar.dart';
import '../widgets/sync_connected_banner.dart';
import '../widgets/sync_item.dart';
import '../widgets/sync_status.dart';

class SyncQueueScreen extends StatelessWidget {
  const SyncQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SyncAppBar(),
            const SyncConnectedBanner(),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SyncItem(
                      name: 'Cocina Del Valle.m4a',
                      duration: '0:32',
                      date: '12 jun',
                      time: '09:28',
                      status: SyncStatus.uploading,
                      progress: 0.67,
                    ),
                    const SizedBox(height: 8),
                    const SyncItem(
                      name: 'Cuarto Iztapalapa.m4a',
                      duration: '1:04',
                      date: '11 jun',
                      time: '16:45',
                      status: SyncStatus.pending,
                    ),
                    const SizedBox(height: 8),
                    const SyncItem(
                      name: 'Bardeo Xochimilco.m4a',
                      duration: '0:18',
                      date: '10 jun',
                      time: '11:03',
                      status: SyncStatus.ready,
                    ),
                    const SizedBox(height: 8),
                    const SyncItem(
                      name: 'Ampliación Techo.m4a',
                      duration: '0:48',
                      date: '9 jun',
                      time: '08:12',
                      status: SyncStatus.error,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Sincronización automática al conectarse · sin acción manual',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
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
}
