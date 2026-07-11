import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../budget/presentation/screens/parameters_review_screen.dart';
import '../../../recording/presentation/providers/recording_providers.dart';

class SyncQueueScreen extends ConsumerWidget {
  const SyncQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncService = ref.watch(syncServiceProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
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
                      ? Center(
                          child: Text(
                            'No hay audios en cola',
                            style: TextStyle(color: context.colors.textSecondary),
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
                                      name: 'Grabación para ${item.proyectoNombre ?? 'Proyecto Desconocido'}',
                                      duration: durationStr,
                                      date: dateStr,
                                      time: timeStr,
                                      status: status,
                                      progress: item.progreso,
                                      onTap: status == _SyncStatus.ready && item.apiId != null
                                          ? () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ParametersReviewScreen(
                                                    grabacionId: item.apiId!,
                                                  ),
                                                ),
                                              );
                                            }
                                          : null,
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
                                    color: context.colors.textSecondary,
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
              color: context.colors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.sync, color: context.colors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sincronización',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                'Subiendo audios al servidor',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.textSecondary,
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
        color: context.colors.primaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi, size: 16, color: context.colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13),
                children: [
                  TextSpan(
                    text: 'Conexión detectada · ',
                    style: TextStyle(color: context.colors.textPrimary),
                  ),
                  TextSpan(
                    text: 'sincronizando automáticamente',
                    style: TextStyle(
                      color: context.colors.primary,
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
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13),
                children: [
                  TextSpan(
                    text: 'Sin conexión · ',
                    style: TextStyle(color: context.colors.textPrimary),
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
  final VoidCallback? onTap;

  const _SyncItem({
    required this.name,
    required this.duration,
    required this.date,
    required this.time,
    required this.status,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _iconBg(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.mic, size: 18, color: _iconColor(context)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Text(
                        '$duration · $date · $time',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.textSecondary,
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
                  backgroundColor: context.colors.border,
                  color: context.colors.primary,
                  minHeight: 4,
                ),
              ),
            ],
            if (onTap != null) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Ver transcripción y resultado',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: context.colors.primary),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _iconBg(BuildContext context) {
    switch (status) {
      case _SyncStatus.uploading:
        return context.colors.primaryLight;
      case _SyncStatus.processing:
        return Colors.blue.withValues(alpha: 0.1);
      case _SyncStatus.pending:
        return context.colors.warningLight;
      case _SyncStatus.ready:
        return context.colors.successLight;
      case _SyncStatus.error:
        return context.colors.errorLight;
    }
  }

  Color _iconColor(BuildContext context) {
    switch (status) {
      case _SyncStatus.uploading:
        return context.colors.primary;
      case _SyncStatus.processing:
        return Colors.blue;
      case _SyncStatus.pending:
        return context.colors.warning;
      case _SyncStatus.ready:
        return context.colors.success;
      case _SyncStatus.error:
        return context.colors.error;
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: context.colors.primary,
          ),
        );
      case _SyncStatus.processing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
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
            color: context.colors.warningLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Pendiente',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.colors.warning,
            ),
          ),
        );
      case _SyncStatus.ready:
        return Row(
          children: [
            Icon(Icons.check, size: 16, color: context.colors.success),
            SizedBox(width: 4),
            Text(
              'Listo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.colors.success,
              ),
            ),
          ],
        );
      case _SyncStatus.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Error',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.colors.error,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Reintentar',
                style: TextStyle(
                  fontSize: 11,
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
    }
  }
}
