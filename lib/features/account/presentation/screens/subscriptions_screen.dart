import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/subscription_entity.dart';
import '../providers/subscriptions_provider.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<SubscriptionsViewModel>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: const BackButton(color: AppColors.textPrimary),
          title: const Text('Mis suscripciones',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              )),
        ),
        body: SafeArea(
          child: Consumer<SubscriptionsViewModel>(
            builder: (context, vm, _) {
              if (vm.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (vm.errorMessage != null) {
                return _Message(text: vm.errorMessage!);
              }
              if (vm.items.isEmpty) {
                return const _Message(text: 'No tienes suscripciones activas.');
              }
              return RefreshIndicator(
                onRefresh: vm.load,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _SubscriptionCard(sub: vm.items[i]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final SubscriptionEntity sub;
  const _SubscriptionCard({required this.sub});

  @override
  Widget build(BuildContext context) {
    final color = sub.activa ? AppColors.success : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium_outlined,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  sub.plan,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sub.estado.isEmpty ? '—' : sub.estado,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          if (sub.precio != null || sub.vigenciaHasta != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            if (sub.precio != null)
              _Row(label: 'Precio', value: '\$${sub.precio!.toStringAsFixed(2)}'),
            if (sub.vigenciaHasta != null)
              _Row(label: 'Vigente hasta', value: sub.vigenciaHasta!),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
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
