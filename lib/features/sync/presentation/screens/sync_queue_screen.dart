import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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
            _SyncAppBar(),
            _ConnectedBanner(),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _SyncItem(
                      name: 'Cocina Del Valle.m4a',
                      duration: '0:32',
                      date: '12 jun',
                      time: '09:28',
                      status: _SyncStatus.uploading,
                      progress: 0.67,
                    ),
                    const SizedBox(height: 8),
                    _SyncItem(
                      name: 'Cuarto Iztapalapa.m4a',
                      duration: '1:04',
                      date: '11 jun',
                      time: '16:45',
                      status: _SyncStatus.pending,
                    ),
                    const SizedBox(height: 8),
                    _SyncItem(
                      name: 'Bardeo Xochimilco.m4a',
                      duration: '0:18',
                      date: '10 jun',
                      time: '11:03',
                      status: _SyncStatus.ready,
                    ),
                    const SizedBox(height: 8),
                    _SyncItem(
                      name: 'Ampliación Techo.m4a',
                      duration: '0:48',
                      date: '9 jun',
                      time: '08:12',
                      status: _SyncStatus.error,
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

enum _SyncStatus { uploading, pending, ready, error }

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
