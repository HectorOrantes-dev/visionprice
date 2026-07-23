import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../budget/presentation/screens/parameters_review_screen.dart';
import '../../../recording/presentation/providers/recording_providers.dart';
import '../widgets/connected_banner.dart';
import '../widgets/offline_banner.dart';
import '../widgets/sync_app_bar.dart';
import '../widgets/sync_item.dart';
import '../widgets/sync_status.dart';

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
                const SyncAppBar(),
                if (isOnline)
                  const ConnectedBanner()
                else
                  const OfflineBanner(),
                const SizedBox(height: 16),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            'No hay audios en cola',
                            style:
                                TextStyle(color: context.colors.textSecondary),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                  itemCount: items.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final item = items[index];
                                    final date =
                                        DateTime.parse(item.fechaGrabacion)
                                            .toLocal();
                                    final dateStr =
                                        DateFormat('d MMM').format(date);
                                    final timeStr =
                                        DateFormat('HH:mm').format(date);

                                    final dur = item.duracionSegundos ?? 0;
                                    final m =
                                        (dur ~/ 60).toString().padLeft(2, '0');
                                    final s =
                                        (dur % 60).toString().padLeft(2, '0');
                                    final durationStr = '$m:$s';

                                    // Map to SyncStatus UI enum
                                    SyncStatus status;
                                    switch (item.estado) {
                                      case 'pending':
                                        status = SyncStatus.pending;
                                        break;
                                      case 'uploading':
                                        status = SyncStatus.uploading;
                                        break;
                                      case 'processing':
                                        status = SyncStatus.processing;
                                        break;
                                      case 'ready':
                                        status = SyncStatus.ready;
                                        break;
                                      case 'error':
                                        status = SyncStatus.error;
                                        break;
                                      default:
                                        status = SyncStatus.pending;
                                    }

                                    return SyncItem(
                                      name:
                                          'Grabación para ${item.proyectoNombre ?? 'Proyecto Desconocido'}',
                                      duration: durationStr,
                                      date: dateStr,
                                      time: timeStr,
                                      status: status,
                                      progress: item.progreso,
                                      onTap: status == SyncStatus.ready &&
                                              item.apiId != null
                                          ? () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ParametersReviewScreen(
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
                                padding:
                                    const EdgeInsets.only(bottom: 16, top: 8),
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
