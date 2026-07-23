import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/plan_catalogo_entity.dart';
import '../providers/payment_method_provider.dart';
import '../providers/subscriptions_provider.dart';
import '../widgets/account_message.dart';
import '../widgets/metodo_tab.dart';
import '../widgets/payment_method.dart';
import '../widgets/payment_method_panel.dart';
import '../widgets/subscription_card.dart';
import 'payment_method_screen.dart';

class SubscriptionsScreen extends ConsumerStatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  ConsumerState<SubscriptionsScreen> createState() =>
      _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen> {
  PlanCatalogoEntity _planSeleccionado = kPlanesDisponibles.first;
  PaymentMethod _metodoSeleccionado = PaymentMethod.conekta;

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => _abrirPago(
                context, _planSeleccionado.planKey, _metodoSeleccionado),
          ),
        ],
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            // Los métodos comparten planKey (el plan elegido en el
            // checklist), así que un solo listener alcanza para mostrar el
            // snackbar de confirmación/error de cualquiera de los dos.
            ref.listen(paymentMethodProvider(_planSeleccionado.planKey),
                (_, next) {
              if (next.confirmMessage == null) return;
              final messenger = ScaffoldMessenger.of(context);
              messenger.hideCurrentSnackBar();
              messenger
                  .showSnackBar(SnackBar(content: Text(next.confirmMessage!)));
            });
            return RefreshIndicator(
              onRefresh: () => ref.refresh(subscriptionsProvider.future),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _sectionTitle(context, 'Métodos de pago disponibles'),
                  const SizedBox(height: 10),
                  Text(
                    'Elige tu plan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final plan in kPlanesDisponibles) ...[
                    _planCheckItem(context, plan),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MetodoTab(
                          label: 'Conekta',
                          selected:
                              _metodoSeleccionado == PaymentMethod.conekta,
                          onTap: () => setState(() =>
                              _metodoSeleccionado = PaymentMethod.conekta),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MetodoTab(
                          label: 'PayPal',
                          selected: _metodoSeleccionado == PaymentMethod.paypal,
                          onTap: () => setState(
                              () => _metodoSeleccionado = PaymentMethod.paypal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _paymentMethodCard(
                    context,
                    child: PaymentMethodPanel(
                      planKey: _planSeleccionado.planKey,
                      metodo: _metodoSeleccionado,
                    ),
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
            );
          },
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

  Widget _planCheckItem(BuildContext context, PlanCatalogoEntity plan) {
    final selected = plan.planKey == _planSeleccionado.planKey;
    return GestureDetector(
      onTap: () => setState(() => _planSeleccionado = plan),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              selected ? context.colors.primaryLight : context.colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? context.colors.primary : context.colors.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected
                  ? context.colors.primary
                  : context.colors.textSecondary,
              size: 22,
            ),
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
              style:
                  TextStyle(fontSize: 12, color: context.colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirPago(BuildContext context, String planKey, PaymentMethod metodo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PaymentMethodScreen(planKey: planKey, metodoInicial: metodo),
      ),
    );
  }

  Widget _paymentMethodCard(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: child,
    );
  }
}
