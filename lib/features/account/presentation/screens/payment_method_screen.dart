import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../providers/payment_method_provider.dart';
import '../widgets/payment_method.dart';
import '../widgets/payment_option_tile.dart';
import '../widgets/subscription_summary_card.dart';
import '../widgets/trust_badges.dart';
import 'conekta_card_token_screen.dart';
import 'paypal_approval_screen.dart';

/// Pantalla "Método de Pago": resumen de suscripción + selección de método
/// (Conekta / PayPal) + confirmar, para el plan [planKey]. Basada en el
/// maquetado de VisionPrice.
class PaymentMethodScreen extends ConsumerWidget {
  final String planKey;
  const PaymentMethodScreen({super.key, required this.planKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = paymentMethodProvider(planKey);
    final vm = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
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
              // Muestra el mensaje de confirmación/error como snackbar.
              if (vm.confirmMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.hideCurrentSnackBar();
                  messenger.showSnackBar(
                    SnackBar(content: Text(vm.confirmMessage!)),
                  );
                  if (vm.exitoso) Navigator.maybePop(context);
                });
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vm.subscription.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, __) =>
                          const SubscriptionSummaryCard(sub: null),
                      data: (sub) => SubscriptionSummaryCard(sub: sub),
                    ),
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
                        onPressed: vm.subscription.isLoading || vm.procesando
                            ? null
                            : () => _confirmar(context, ref, notifier, vm),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                          shadowColor:
                              context.colors.primary.withValues(alpha: 0.4),
                        ),
                        child: vm.procesando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Row(
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
        ));
  }

  Future<void> _confirmar(
    BuildContext context,
    WidgetRef ref,
    PaymentMethodNotifier notifier,
    PaymentMethodState vm,
  ) async {
    if (vm.selected == PaymentMethod.conekta) {
      final cardToken = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => const ConektaCardTokenScreen()),
      );
      if (cardToken == null || !context.mounted) return;
      await notifier.confirmarConekta(cardToken);
      return;
    }

    // PayPal: primero crea el intento (obtiene la approval_url), luego abre
    // el WebView de aprobación y por último refresca el estado.
    final approvalUrl = await notifier.iniciarPaypal();
    if (approvalUrl == null || approvalUrl.isEmpty || !context.mounted) {
      return;
    }
    final aprobado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PaypalApprovalScreen(approvalUrl: approvalUrl),
      ),
    );
    if (!context.mounted) return;
    await notifier.finalizarPaypal(aprobado: aprobado ?? false);
  }
}
