import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../recording/domain/entities/superficie_entity.dart';
import '../providers/cotizacion_wizard_provider.dart';
import '../widgets/superficie_card.dart';
import '../widgets/superficies_header.dart';
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
            SuperficiesHeader(loading: vm.loading),
            Expanded(
              child: vm.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      itemCount: vm.superficies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => SuperficieCard(
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
