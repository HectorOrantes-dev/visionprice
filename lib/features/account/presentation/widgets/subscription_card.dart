import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../auth/presentation/providers/perfil_provider.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../domain/entities/subscription_entity.dart';
import '../providers/account_providers.dart';
import '../providers/subscriptions_provider.dart';
import 'subscription_info_row.dart';

/// Tarjeta de una suscripción, con acciones de gestión (cancelar / quitar
/// tarjeta) cuando aplican.
class SubscriptionCard extends ConsumerStatefulWidget {
  final SubscriptionEntity sub;
  const SubscriptionCard({super.key, required this.sub});

  @override
  ConsumerState<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends ConsumerState<SubscriptionCard> {
  bool _procesando = false;

  Future<bool> _confirmar(String titulo, String cuerpo) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(cuerpo),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí, continuar'),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _ejecutar(Future<void> Function() accion) async {
    setState(() => _procesando = true);
    try {
      await accion();
      // La suscripción cambió (cancelada) o la tarjeta se quitó: el plan del
      // perfil, la cuota gratis y esta misma lista quedan con datos viejos.
      ref.read(perfilProvider.notifier).refresh();
      ref.invalidate(usoCotizacionesProvider);
      ref.invalidate(subscriptionsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Listo.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e is ApiException ? e.message : 'No se pudo completar la acción.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _procesando = false);
    }
  }

  Future<void> _cancelar() async {
    final confirmado = await _confirmar(
      'Cancelar suscripción',
      '¿Seguro que quieres cancelar tu suscripción? Perderás el acceso a las '
          'funciones de pago cuando termine tu periodo vigente.',
    );
    if (!confirmado) return;
    final sub = widget.sub;
    if (sub.esPaypal) {
      // El endpoint espera la PK interna de Pagos (`id`, un UUID), NO el
      // `provider_subscription_id` de PayPal (ej. "I-XXXX...") — mandar ese
      // daba 404 y la suscripción se quedaba activa sin que nadie lo notara.
      final id = sub.id;
      if (id == null || id.isEmpty) return;
      await _ejecutar(() => ref.read(cancelarSuscripcionPaypalUseCaseProvider)(
          subscriptionId: id));
    } else {
      await _ejecutar(
          () => ref.read(cancelarSuscripcionConektaUseCaseProvider)());
    }
  }

  Future<void> _quitarTarjeta() async {
    final confirmado = await _confirmar(
      'Quitar tarjeta',
      '¿Quitar la tarjeta guardada en Conekta? No podrás cobrar renovaciones '
          'automáticas hasta que agregues otra.',
    );
    if (!confirmado) return;
    await _ejecutar(() => ref.read(eliminarMetodoPagoConektaUseCaseProvider)());
  }

  @override
  Widget build(BuildContext context) {
    final sub = widget.sub;
    final color =
        sub.activa ? context.colors.success : context.colors.textSecondary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium_outlined,
                  color: context.colors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  sub.plan,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sub.estado.isEmpty ? '—' : sub.estado,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          if (sub.precio != null || sub.vigenciaHasta != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            if (sub.precio != null)
              SubscriptionInfoRow(
                  label: 'Precio',
                  value: '\$${sub.precio!.toStringAsFixed(2)}'),
            if (sub.vigenciaHasta != null)
              SubscriptionInfoRow(
                  label: 'Vigente hasta', value: sub.vigenciaHasta!),
          ],
          if (sub.activa || sub.esConekta) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                if (sub.activa)
                  Expanded(
                    child: TextButton(
                      onPressed: _procesando ? null : _cancelar,
                      style: TextButton.styleFrom(
                        foregroundColor: context.colors.error,
                      ),
                      child: const Text('Cancelar suscripción'),
                    ),
                  ),
                if (sub.esConekta)
                  Expanded(
                    child: TextButton(
                      onPressed: _procesando ? null : _quitarTarjeta,
                      child: const Text('Quitar tarjeta'),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
