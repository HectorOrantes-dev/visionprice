import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../providers/payment_method_provider.dart';
import '../widgets/metodo_tab.dart';
import '../widgets/payment_method.dart';
import '../widgets/payment_method_panel.dart';
import '../widgets/subscription_summary_card.dart';
import '../widgets/trust_badges.dart';

/// Pantalla "Método de Pago" para el plan [planKey]: resumen de suscripción +
/// pestañas Conekta/PayPal (empezando en [metodoInicial], según desde dónde
/// se haya abierto) + [PaymentMethodPanel] del método activo. Así se puede
/// pagar CUALQUIER plan (no solo el primero del catálogo) con cualquiera de
/// los dos métodos. Basada en el maquetado de VisionPrice.
class PaymentMethodScreen extends ConsumerStatefulWidget {
  final String planKey;
  final PaymentMethod metodoInicial;
  const PaymentMethodScreen({
    super.key,
    required this.planKey,
    this.metodoInicial = PaymentMethod.conekta,
  });

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  late PaymentMethod _metodo = widget.metodoInicial;

  @override
  Widget build(BuildContext context) {
    final provider = paymentMethodProvider(widget.planKey);
    final vm = ref.watch(provider);
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
                      'Tu método de pago',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: MetodoTab(
                            label: 'Conekta',
                            selected: _metodo == PaymentMethod.conekta,
                            onTap: () =>
                                setState(() => _metodo = PaymentMethod.conekta),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MetodoTab(
                            label: 'PayPal',
                            selected: _metodo == PaymentMethod.paypal,
                            onTap: () =>
                                setState(() => _metodo = PaymentMethod.paypal),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PaymentMethodPanel(
                        planKey: widget.planKey, metodo: _metodo),
                    const SizedBox(height: 20),
                    const TrustBadges(),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
