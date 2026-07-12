import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../recording/domain/entities/superficie_entity.dart';
import '../providers/cotizacion_wizard_provider.dart';
import 'elegir_material_screen.dart';
import 'resumen_cotizacion_screen.dart';

/// 01 · Superficies detectadas — primera pantalla del wizard de cotización
/// por voz: lista las superficies que el ML identificó en la transcripción y
/// deja elegir el material de cada una antes de poder continuar.
class SuperficiesDetectadasScreen extends ConsumerStatefulWidget {
  final int proyectoId;
  final List<SuperficieEntity> superficies;

  const SuperficiesDetectadasScreen({
    super.key,
    required this.proyectoId,
    required this.superficies,
  });

  @override
  ConsumerState<SuperficiesDetectadasScreen> createState() =>
      _SuperficiesDetectadasScreenState();
}

class _SuperficiesDetectadasScreenState
    extends ConsumerState<SuperficiesDetectadasScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(cotizacionWizardProvider(widget.proyectoId).notifier)
        .cargar(widget.superficies));
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(cotizacionWizardProvider(widget.proyectoId));

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(loading: vm.loading),
            Expanded(
              child: vm.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      itemCount: vm.superficies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _SuperficieCard(
                        proyectoId: widget.proyectoId,
                        index: i,
                        state: vm,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: GradientButton(
                height: 52,
                onPressed: vm.todasCompletas
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResumenCotizacionScreen(
                                proyectoId: widget.proyectoId),
                          ),
                        )
                    : null,
                child: Text(
                    'Continuar (${vm.completadas} de ${vm.superficies.length} listas)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool loading;
  const _Header({required this.loading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(bottom: BorderSide(color: context.colors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 18, color: context.colors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Superficies detectadas',
                  style: AppTextStyles.heading(size: 22, color: context.colors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Revisa lo que identificamos en tu grabación.',
                  style: TextStyle(fontSize: 13, color: context.colors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuperficieCard extends StatelessWidget {
  final int proyectoId;
  final int index;
  final CotizacionWizardState state;
  const _SuperficieCard({
    required this.proyectoId,
    required this.index,
    required this.state,
  });

  IconData get _icon {
    switch (state.superficies[index].tipo.toLowerCase().trim()) {
      case 'piso':
        return Icons.grid_view_rounded;
      case 'azulejo':
        return Icons.window_outlined;
      case 'zoclo':
        return Icons.straighten;
      case 'pintura':
      case 'pared':
        return Icons.format_paint_outlined;
      default:
        return Icons.construction_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sup = state.superficies[index];
    final regla = state.reglaDe(index);
    final completa = state.superficieCompleta(index);
    final nombreElegido = regla.requiereKit
        ? state.seleccionKit[index]?.principal?.nombre
        : state.seleccionSimple[index]?.nombre;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ElegirMaterialScreen(proyectoId: proyectoId, index: index),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: context.colors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_icon, color: context.colors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          sup.descripcion,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.heading(
                              size: 15, weight: FontWeight.w700, color: context.colors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: regla.requiereKit
                              ? context.colors.primaryLight
                              : context.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          regla.requiereKit ? 'Kit de instalación' : 'Material simple',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: regla.requiereKit
                                ? context.colors.primary
                                : context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  if (completa && nombreElegido != null)
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 14, color: context.colors.success),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            nombreElegido,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600, color: context.colors.success),
                          ),
                        ),
                      ],
                    )
                  else
                    Text('Sin material elegido',
                        style: TextStyle(fontSize: 12, color: context.colors.textHint)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${sup.areaM2.toStringAsFixed(sup.areaM2.truncateToDouble() == sup.areaM2 ? 0 : 1)} m²',
              style: AppTextStyles.heading(size: 14, weight: FontWeight.w800, color: context.colors.primary),
            ),
            Icon(Icons.chevron_right, color: context.colors.textHint),
          ],
        ),
      ),
    );
  }
}
