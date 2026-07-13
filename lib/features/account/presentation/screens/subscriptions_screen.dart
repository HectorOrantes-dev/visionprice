import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../providers/subscriptions_provider.dart';
import '../widgets/account_message.dart';
import '../widgets/subscription_card.dart';
import 'payment_method_screen.dart';

class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsAsync = ref.watch(subscriptionsProvider);
    return Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.background,
          elevation: 0,
          leading: BackButton(color: context.colors.textPrimary),
          title: Text('Mis suscripciones',
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              )),
          actions: [
            IconButton(
              tooltip: 'Método de pago',
              icon: Icon(Icons.credit_card, color: context.colors.primary),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PaymentMethodScreen()),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: subsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => AccountMessage(
                text: e is ApiException
                    ? e.message
                    : 'No se pudieron cargar las suscripciones.'),
            data: (items) {
              if (items.isEmpty) {
                return const AccountMessage(
                    text: 'No tienes suscripciones activas.');
              }
              return RefreshIndicator(
                onRefresh: () => ref.refresh(subscriptionsProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => SubscriptionCard(sub: items[i]),
                ),
              );
            },
          ),
        ),
    );
  }
}
