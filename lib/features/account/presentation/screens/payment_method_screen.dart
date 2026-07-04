import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/payment_method_provider.dart';
import '../widgets/payment_method.dart';
import '../widgets/payment_option_tile.dart';
import '../widgets/subscription_summary_card.dart';
import '../widgets/trust_badges.dart';

/// Pantalla "Método de Pago": resumen de suscripción + selección de método
/// (Conekta / PayPal) + confirmar. Basada en el maquetado de VisionPrice.
class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<PaymentMethodViewModel>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          leading: const BackButton(color: AppColors.primary),
          title: const Text(
            'Método de Pago',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Consumer<PaymentMethodViewModel>(
            builder: (context, vm, _) {
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
                    const Text(
                      'Selecciona tu método de pago',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    PaymentOptionTile(
                      logo: Icons.credit_card,
                      title: 'Conekta',
                      subtitle: 'Tarjeta de Crédito / Débito o Efectivo',
                      selected: vm.selected == PaymentMethod.conekta,
                      onTap: () => vm.seleccionar(PaymentMethod.conekta),
                    ),
                    const SizedBox(height: 12),
                    PaymentOptionTile(
                      logo: Icons.account_balance_wallet_outlined,
                      title: 'PayPal',
                      subtitle:
                          'Paga de forma rápida y segura con tu cuenta PayPal',
                      selected: vm.selected == PaymentMethod.paypal,
                      onTap: () => vm.seleccionar(PaymentMethod.paypal),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: vm.loading ? null : vm.confirmar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
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
      ),
    );
  }
}
