import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/notificacion_entity.dart';
import '../providers/notifications_provider.dart';

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
                return _Message(text: vm.errorMessage!);
              }
              if (vm.items.isEmpty) {
                return const _Message(text: 'No tienes notificaciones.');
              }
              return RefreshIndicator(
                onRefresh: vm.load,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _NotifCard(
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

class _NotifCard extends StatelessWidget {
  final NotificacionEntity notif;
  final VoidCallback onTap;
  const _NotifCard({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final leida = notif.leida;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: leida ? AppColors.surface : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: leida ? AppColors.border : AppColors.primary,
            width: leida ? 1 : 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: leida ? AppColors.surfaceVariant : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _iconFor(notif.tipo),
                size: 18,
                color: leida ? AppColors.textSecondary : AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.titulo.isEmpty ? notif.tipo : notif.titulo,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: leida ? FontWeight.w600 : FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notif.cuerpo,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  if (notif.fechaCreacion != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      notif.fechaCreacion!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!leida)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 8, top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String tipo) {
    final t = tipo.toLowerCase();
    if (t.contains('venc') || t.contains('pago')) return Icons.payments_outlined;
    if (t.contains('graba') || t.contains('audio')) return Icons.mic_none;
    if (t.contains('cotiz')) return Icons.receipt_long_outlined;
    return Icons.notifications_none;
  }
}

class _Message extends StatelessWidget {
  final String text;
  const _Message({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
