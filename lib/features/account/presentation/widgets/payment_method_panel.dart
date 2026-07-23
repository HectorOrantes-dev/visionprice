import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/payment_method_provider.dart';
import '../screens/conekta_card_token_screen.dart';
import '../screens/conekta_checkout_webview_screen.dart';
import '../screens/paypal_approval_screen.dart';
import 'payment_method.dart';
import 'payment_option_tile.dart';
import 'paypal_pay_button.dart';

/// Contenido de pago (Conekta con sus sub-métodos, o PayPal) + botón
/// "Confirmar y Pagar", listo para pagar directo sin pasar por otra
/// pantalla — se usa embebido en "Métodos de pago disponibles"
/// ([SubscriptionsScreen]) y también dentro de [PaymentMethodScreen].
class PaymentMethodPanel extends ConsumerWidget {
  final String planKey;
  final PaymentMethod metodo;
  const PaymentMethodPanel({
    super.key,
    required this.planKey,
    required this.metodo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = paymentMethodProvider(planKey);
    final vm = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (metodo == PaymentMethod.conekta) ...[
          PaymentOptionTile(
            logo: Icons.credit_card,
            logoWidget: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                'c',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF4338CA),
                ),
              ),
            ),
            title: 'Conekta',
            subtitle: _conektaSubtitle(vm.conektaMetodo),
            selected: true,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          Text(
            '¿Cómo quieres pagar con Conekta?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ConektaMetodoChip(
                  label: 'Tarjeta',
                  icon: Icons.credit_card,
                  selected: vm.conektaMetodo == ConektaMetodo.tarjeta,
                  onTap: () =>
                      notifier.seleccionarConektaMetodo(ConektaMetodo.tarjeta),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ConektaMetodoChip(
                  label: 'Efectivo',
                  icon: Icons.storefront_outlined,
                  selected: vm.conektaMetodo == ConektaMetodo.efectivo,
                  onTap: () =>
                      notifier.seleccionarConektaMetodo(ConektaMetodo.efectivo),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ConektaMetodoChip(
                  label: 'Transferencia',
                  icon: Icons.account_balance_outlined,
                  selected: vm.conektaMetodo == ConektaMetodo.transferencia,
                  onTap: () => notifier
                      .seleccionarConektaMetodo(ConektaMetodo.transferencia),
                ),
              ),
            ],
          ),
        ] else
          Center(
            child: PaypalPayButton(
              selected: true,
              onTap: () {},
            ),
          ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: vm.subscription.isLoading || vm.procesando
                ? null
                : () => _confirmar(context, notifier, vm),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              shadowColor: context.colors.primary.withValues(alpha: 0.4),
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
                      Icon(Icons.lock_outline, size: 20, color: Colors.white),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmar(
    BuildContext context,
    PaymentMethodNotifier notifier,
    PaymentMethodState vm,
  ) async {
    if (metodo == PaymentMethod.conekta) {
      if (vm.conektaMetodo == ConektaMetodo.tarjeta) {
        final cardToken = await Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (_) => const ConektaCardTokenScreen()),
        );
        if (cardToken == null || !context.mounted) return;
        await notifier.confirmarConekta(cardToken);
        return;
      }

      // Efectivo (OXXO) / transferencia (SPEI): checkout hospedado, no
      // cobra en este request — el usuario paga fuera de la app.
      final checkoutUrl = await notifier.iniciarConektaCheckout();
      if (checkoutUrl == null || checkoutUrl.isEmpty || !context.mounted) {
        return;
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ConektaCheckoutWebviewScreen(checkoutUrl: checkoutUrl),
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cuando completes tu pago, tu suscripción se activará automáticamente.',
          ),
        ),
      );
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

  String _conektaSubtitle(ConektaMetodo metodo) {
    switch (metodo) {
      case ConektaMetodo.tarjeta:
        return 'Tarjeta de Crédito / Débito';
      case ConektaMetodo.efectivo:
        return 'Pago en efectivo (OXXO)';
      case ConektaMetodo.transferencia:
        return 'Transferencia bancaria (SPEI)';
    }
  }
}

/// Chip compacto para elegir el sub-método dentro de Conekta (tarjeta,
/// efectivo o transferencia) — cada uno dispara un flujo de cobro distinto
/// en el back-end (suscripción recurrente vs. checkout hospedado).
class _ConektaMetodoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ConektaMetodoChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color:
              selected ? context.colors.primaryLight : context.colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? context.colors.primary : context.colors.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? context.colors.primary
                  : context.colors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: selected
                    ? context.colors.textPrimary
                    : context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
