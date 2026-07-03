import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notif_card.dart';
import '../widgets/notif_message.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<NotificationsViewModel>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: const BackButton(color: AppColors.textPrimary),
          title: const Text('Notificaciones',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              )),
        ),
        body: SafeArea(
          child: Consumer<NotificationsViewModel>(
            builder: (context, vm, _) {
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
                onRefresh: vm.load,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => NotifCard(
                    notif: vm.items[i],
                    onTap: () => vm.marcarLeida(vm.items[i].id),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
