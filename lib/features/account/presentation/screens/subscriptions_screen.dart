import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/plan_catalogo_entity.dart';
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
              MaterialPageRoute(builder: (_) => const PaymentMethodScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(subscriptionsProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionTitle(context, 'Planes disponibles'),
              const SizedBox(height: 10),
              for (final plan in kPlanesDisponibles) ...[
                _planCard(context, plan),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 16),
              _sectionTitle(context, 'Métodos de pago disponibles'),
              const SizedBox(height: 10),
              _paymentMethodRow(
                context,
                icon: Icons.credit_card,
                title: 'Conekta',
                subtitle: 'Tarjeta de crédito / débito o efectivo',
              ),
              const SizedBox(height: 10),
              _paymentMethodRow(
                context,
                icon: Icons.account_balance_wallet_outlined,
                title: 'PayPal',
                subtitle: 'Paga con tu cuenta PayPal',
              ),
              const SizedBox(height: 24),
              _sectionTitle(context, 'Mis suscripciones'),
              const SizedBox(height: 10),
              subsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => AccountMessage(
                    text: e is ApiException
                        ? e.message
                        : 'No se pudieron cargar las suscripciones.'),
                data: (items) {
                  if (items.isEmpty) {
                    return const AccountMessage(
                        text: 'No tienes suscripciones activas.');
                  }
                  return Column(
                    children: [
                      for (final sub in items) ...[
                        SubscriptionCard(sub: sub),
                        const SizedBox(height: 12),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) => Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: context.colors.textSecondary,
        ),
      );

  Widget _planCard(BuildContext context, PlanCatalogoEntity plan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_outlined,
              color: context.colors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              plan.nombre,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          Text(
            '\$${plan.precio.toStringAsFixed(0)} ${plan.moneda}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '/${plan.intervalo}',
            style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaymentMethodScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: context.colors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 12, color: context.colors.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.colors.textSecondary),
          ],
        ),
      ),
    );
  }
}
