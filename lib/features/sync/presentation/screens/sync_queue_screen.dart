import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../services/sync_service.dart';

class SyncQueueScreen extends StatelessWidget {
  const SyncQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final syncService = getIt<SyncService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: syncService,
          builder: (context, _) {
            final items = syncService.items;
            final isOnline = syncService.isOnline;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SyncAppBar(),
                if (isOnline) _ConnectedBanner() else _OfflineBanner(),
                const SizedBox(height: 16),
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'No hay audios en cola',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                  itemCount: items.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final item = items[index];
                                    final date = DateTime.parse(item.fechaGrabacion).toLocal();
                                    final dateStr = DateFormat('d MMM').format(date);
                                    final timeStr = DateFormat('HH:mm').format(date);
                                    
                                    final dur = item.duracionSegundos ?? 0;
                                    final m = (dur ~/ 60).toString().padLeft(2, '0');
                                    final s = (dur % 60).toString().padLeft(2, '0');
                                    final durationStr = '$m:$s';
                                    
                                    // Map to SyncStatus UI enum
                                    _SyncStatus status;
                                    switch (item.estado) {
                                      case 'pending': status = _SyncStatus.pending; break;
                                      case 'uploading': status = _SyncStatus.uploading; break;
                                      case 'processing': status = _SyncStatus.processing; break;
                                      case 'ready': status = _SyncStatus.ready; break;
                                      case 'error': status = _SyncStatus.error; break;
                                      default: status = _SyncStatus.pending;
                                    }
                                    
                                    return _SyncItem(
                                      name: p.basename(item.audioPath),
                                      duration: durationStr,
                                      date: dateStr,
                                      time: timeStr,
                                      status: status,
                                      progress: item.progreso,
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16, top: 8),
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
            );
          },
        ),
      ),
    );
  }
}


class _SyncAppBar extends StatelessWidget {
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
            child: const Icon(Icons.sync, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sincronización',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Subiendo audios al servidor',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConnectedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13),
                children: [
                  TextSpan(
                    text: 'Conexión detectada · ',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  TextSpan(
                    text: 'sincronizando automáticamente',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13),
                children: [
                  TextSpan(
                    text: 'Sin conexión · ',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  TextSpan(
                    text: 'esperando red para subir',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _SyncStatus { uploading, processing, pending, ready, error }

class _SyncItem extends StatelessWidget {
  final String name;
  final String duration;
  final String date;
  final String time;
  final _SyncStatus status;
  final double? progress;

  const _SyncItem({
    required this.name,
    required this.duration,
    required this.date,
    required this.time,
    required this.status,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.mic, size: 18, color: _iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$duration · $date · $time',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusWidget(status: status, progress: progress),
              ],
            ),
            if (status == _SyncStatus.uploading && progress != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.border,
                  color: AppColors.primary,
                  minHeight: 4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _iconBg {
    switch (status) {
      case _SyncStatus.uploading:
        return AppColors.primaryLight;
      case _SyncStatus.processing:
        return Colors.blue.withOpacity(0.1);
      case _SyncStatus.pending:
        return AppColors.warningLight;
      case _SyncStatus.ready:
        return AppColors.successLight;
      case _SyncStatus.error:
        return AppColors.errorLight;
    }
  }

  Color get _iconColor {
    switch (status) {
      case _SyncStatus.uploading:
        return AppColors.primary;
      case _SyncStatus.processing:
        return Colors.blue;
      case _SyncStatus.pending:
        return AppColors.warning;
      case _SyncStatus.ready:
        return AppColors.success;
      case _SyncStatus.error:
        return AppColors.error;
    }
  }
}

class _StatusWidget extends StatelessWidget {
  final _SyncStatus status;
  final double? progress;

  const _StatusWidget({required this.status, this.progress});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _SyncStatus.uploading:
        return Text(
          '${((progress ?? 0) * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        );
      case _SyncStatus.processing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
              ),
              SizedBox(width: 6),
              Text(
                'Procesando',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        );
      case _SyncStatus.pending:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warningLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Pendiente',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.warning,
            ),
          ),
        );
      case _SyncStatus.ready:
        return const Row(
          children: [
            Icon(Icons.check, size: 16, color: AppColors.success),
            SizedBox(width: 4),
            Text(
              'Listo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ],
        );
      case _SyncStatus.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Error',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Reintentar',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
    }
  }
}
