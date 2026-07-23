import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/budget_providers.dart';

/// "N/20 cotizaciones gratis usadas" — se oculta sola con plan activo
/// (`ilimitado: true`) o mientras carga/falla (no vale la pena mostrar un
/// error por esto, es informativo).
class UsoCotizacionesBanner extends ConsumerWidget {
  const UsoCotizacionesBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usoAsync = ref.watch(usoCotizacionesProvider);
    return usoAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (uso) {
        if (uso.ilimitado) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: context.colors.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.workspace_premium_outlined,
                  size: 18, color: context.colors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${uso.usadas}/${uso.limiteGratis} cotizaciones gratis usadas',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
