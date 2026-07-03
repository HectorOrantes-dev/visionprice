import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/subscriptions_provider.dart';
import '../widgets/account_message.dart';
import '../widgets/subscription_card.dart';

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
                return AccountMessage(text: vm.errorMessage!);
              }
              if (vm.items.isEmpty) {
                return const AccountMessage(
                    text: 'No tienes suscripciones activas.');
              }
              return RefreshIndicator(
                onRefresh: vm.load,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => SubscriptionCard(sub: vm.items[i]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
