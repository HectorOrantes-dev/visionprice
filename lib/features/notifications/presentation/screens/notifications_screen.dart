import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notif_card.dart';
import '../widgets/notif_message.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(notificationsProvider);
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
        child: Builder(
          builder: (context) {
            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.errorMessage != null) {
              return NotifMessage(text: vm.errorMessage!);
            }
            if (vm.items.isEmpty) {
              return const NotifMessage(text: 'No tienes notificaciones.');
            }
            return RefreshIndicator(
              onRefresh: notifier.load,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: vm.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => NotifCard(
                  notif: vm.items[i],
                  onTap: () => notifier.marcarLeida(vm.items[i].id),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
