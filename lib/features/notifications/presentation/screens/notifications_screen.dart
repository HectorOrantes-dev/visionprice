import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notif_card.dart';
import '../widgets/notif_message.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Notificaciones',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: notifsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => NotifMessage(
              text: e is ApiException
                  ? e.message
                  : 'No se pudieron cargar las notificaciones.'),
          data: (items) {
            if (items.isEmpty) {
              return const NotifMessage(text: 'No tienes notificaciones.');
            }
            return RefreshIndicator(
              onRefresh: () => ref.refresh(notificationsProvider.future),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => NotifCard(
                  notif: items[i],
                  onTap: () => notifier.marcarLeida(items[i].id),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
