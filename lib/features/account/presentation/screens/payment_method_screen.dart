import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../providers/payment_method_provider.dart';
import '../widgets/payment_method.dart';
import '../widgets/payment_option_tile.dart';
import '../widgets/subscription_summary_card.dart';
import '../widgets/trust_badges.dart';

/// Pantalla "Método de Pago": resumen de suscripción + selección de método
/// (Conekta / PayPal) + confirmar. Basada en el maquetado de VisionPrice.
class PaymentMethodScreen extends ConsumerWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(paymentMethodNotifierProvider);
    final notifier = ref.read(paymentMethodNotifierProvider.notifier);
    return Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.background,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          leading: BackButton(color: context.colors.primary),
          title: Text(
            'Método de Pago',
            style: TextStyle(
              color: context.colors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              // Muestra el mensaje de confirmación (placeholder) como snackbar.
              if (vm.confirmMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.hideCurrentSnackBar();
                  messenger.showSnackBar(
                    SnackBar(content: Text(vm.confirmMessage!)),
                  );
                });
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (vm.loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      SubscriptionSummaryCard(sub: vm.subscription),
                    const SizedBox(height: 24),
                    Text(
                      'Selecciona tu método de pago',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    PaymentOptionTile(
                      logo: Icons.credit_card,
                      title: 'Conekta',
                      subtitle: 'Tarjeta de Crédito / Débito o Efectivo',
                      selected: vm.selected == PaymentMethod.conekta,
                      onTap: () => notifier.seleccionar(PaymentMethod.conekta),
                    ),
                    const SizedBox(height: 12),
                    PaymentOptionTile(
                      logo: Icons.account_balance_wallet_outlined,
                      title: 'PayPal',
                      subtitle:
                          'Paga de forma rápida y segura con tu cuenta PayPal',
                      selected: vm.selected == PaymentMethod.paypal,
                      onTap: () => notifier.seleccionar(PaymentMethod.paypal),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: vm.loading ? null : notifier.confirmar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                          shadowColor: context.colors.primary.withValues(alpha: 0.4),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Confirmar y Pagar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.lock_outline,
                                size: 20, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TrustBadges(),
                  ],
                ),
              );
            },
          ),
        ),
    );
  }
}
