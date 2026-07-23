import 'package:flutter/material.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import 'subscriptions_screen.dart';

/// Paywall mostrado cuando cualquier request responde 402: llegaste al
/// límite de cotizaciones gratis (`plan_limit_reached`) o la función exige
/// suscripción activa (`plan_required`, p. ej. audio). Un solo botón manda a
/// [SubscriptionsScreen] para elegir plan y pagar.
class PlanPaywallScreen extends StatelessWidget {
  final String? code;
  final String message;

  const PlanPaywallScreen(
      {super.key, required this.code, required this.message});

  /// Muestra el paywall si [error] es un 402 de plan; si no, no hace nada y
  /// devuelve `false` (para que el llamador siga con su manejo normal de
  /// error, p. ej. un snackbar genérico).
  static bool mostrarSiAplica(BuildContext context, Object error) {
    if (error is! ApiException || !error.isPaymentRequired) return false;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PlanPaywallScreen(code: error.code, message: error.message),
      ),
    );
    return true;
  }

  bool get _esLimiteGratis => code == 'plan_limit_reached';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: context.colors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _esLimiteGratis
                      ? Icons.workspace_premium_outlined
                      : Icons.lock_outline,
                  size: 40,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _esLimiteGratis
                    ? 'Llegaste al límite de tu plan gratis'
                    : 'Esta función requiere suscripción',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: context.colors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SubscriptionsScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Ver planes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
