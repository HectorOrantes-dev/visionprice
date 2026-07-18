import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../providers/cotizacion_wizard_provider.dart';
import '../widgets/mano_obra_field.dart';
import '../widgets/total_mano_obra.dart';
import 'cotizacion_lista_screen.dart';
import 'elegir_material_screen.dart';

/// 04 · Resumen del proyecto — última confirmación antes de crear la(s)
/// cotización(es), con acceso rápido a corregir el material de cualquier
/// superficie y la captura del costo de **mano de obra** (pintura y/o piso).
class ResumenCotizacionScreen extends ConsumerStatefulWidget {
  final int proyectoId;
  const ResumenCotizacionScreen({super.key, required this.proyectoId});

  static String _fmtArea(double a) => a.truncateToDouble() == a ? a.toStringAsFixed(0) : a.toStringAsFixed(1);

  @override
  ConsumerState<ResumenCotizacionScreen> createState() =>
      _ResumenCotizacionScreenState();
}

class _ResumenCotizacionScreenState
    extends ConsumerState<ResumenCotizacionScreen> {
  late final TextEditingController _manoObraSimpleCtrl;
  late final TextEditingController _manoObraKitCtrl;

  @override
  void initState() {
    super.initState();
    final st = ref.read(cotizacionWizardProvider(widget.proyectoId));
    _manoObraSimpleCtrl = TextEditingController(
        text: st.manoObraSimple != null ? _fmt(st.manoObraSimple!) : '');
    _manoObraKitCtrl = TextEditingController(
        text: st.manoObraKit != null ? _fmt(st.manoObraKit!) : '');
  }

  static String _fmt(double v) =>
      v.truncateToDouble() == v ? v.toStringAsFixed(0) : v.toString();

  @override
  void dispose() {
    _manoObraSimpleCtrl.dispose();
    _manoObraKitCtrl.dispose();
    super.dispose();
  }

  String _resumenMateriales(CotizacionWizardState vm, int i) {
    final regla = vm.reglaDe(i);
    if (!regla.requiereKit) {
      return vm.seleccionSimple[i]?.nombre ?? 'Sin elegir';
    }
    final kit = vm.seleccionKit[i];
    final partes = <String>[
      if (kit?.principal != null) kit!.principal!.nombre,
      if (kit?.adhesivo != null) kit!.adhesivo!.nombre,
      if (kit?.cruceta != null) kit!.cruceta!.nombre,
      if (kit?.boquilla != null) kit!.boquilla!.nombre,
    ];
    return partes.isEmpty ? 'Sin elegir' : partes.join(' + ');
  }

  @override
  Widget build(BuildContext context) {
    final proyectoId = widget.proyectoId;
    final vm = ref.watch(cotizacionWizardProvider(proyectoId));
    final notifier = ref.read(cotizacionWizardProvider(proyectoId).notifier);

    final hayKit = List.generate(vm.superficies.length, (i) => i).any((i) => vm.reglaDe(i).requiereKit);
    final haySimple = List.generate(vm.superficies.length, (i) => i).any((i) => !vm.reglaDe(i).requiereKit);
    final mixto = hayKit && haySimple;

    // Áreas por tipo, para mostrar el total en vivo (tarifa × área).
    var areaSimple = 0.0;
    var areaKit = 0.0;
    for (var i = 0; i < vm.superficies.length; i++) {
      if (vm.reglaDe(i).requiereKit) {
        areaKit += vm.superficies[i].areaM2;
      } else {
        areaSimple += vm.superficies[i].areaM2;
      }
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 14),
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
                    child: Text('Resumen del proyecto',
                        style: AppTextStyles.heading(size: 20, color: context.colors.textPrimary)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                children: [
                  for (var i = 0; i < vm.superficies.length; i++) ...[
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ElegirMaterialScreen(proyectoId: proyectoId, index: i),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.colors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${vm.superficies[i].descripcion} · ${ResumenCotizacionScreen._fmtArea(vm.superficies[i].areaM2)} m²',
                                    style: AppTextStyles.heading(
                                        size: 14, weight: FontWeight.w700, color: context.colors.textPrimary),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    _resumenMateriales(vm, i),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.edit_outlined, size: 18, color: context.colors.primary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // --- Mano de obra ---
                  const SizedBox(height: 4),
                  Text('MANO DE OBRA',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: context.colors.textSecondary,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(
                    'Tarifa por m². Se multiplica por el área, se suma al total y aparece como línea en el PDF.',
                    style: TextStyle(fontSize: 12, color: context.colors.textHint, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  if (haySimple) ...[
                    ManoObraField(
                      controller: _manoObraSimpleCtrl,
                      label: mixto ? 'Mano de obra por m² · pintura' : 'Mano de obra por m²',
                      onChanged: (v) => notifier.setManoObraSimple(_parse(v)),
                    ),
                    TotalManoObra(tarifa: vm.manoObraSimple, area: areaSimple),
                  ],
                  if (mixto) const SizedBox(height: 10),
                  if (hayKit) ...[
                    ManoObraField(
                      controller: _manoObraKitCtrl,
                      label: mixto ? 'Mano de obra por m² · piso' : 'Mano de obra por m²',
                      onChanged: (v) => notifier.setManoObraKit(_parse(v)),
                    ),
                    TotalManoObra(tarifa: vm.manoObraKit, area: areaKit),
                  ],

                  if (mixto) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: context.colors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, size: 16, color: context.colors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Se generarán 2 cotizaciones: una de materiales simples y otra de kit.',
                              style: TextStyle(fontSize: 12, color: context.colors.textPrimary, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (vm.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(vm.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GradientButton(
                height: 52,
                onPressed: vm.creando
                    ? null
                    : () async {
                        final creadas = await notifier.crearCotizaciones();
                        if (creadas.isEmpty || !context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CotizacionListaScreen(
                              cotizaciones: creadas,
                              proyectoId: proyectoId,
                            ),
                          ),
                        );
                      },
                child: vm.creando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 18),
                          SizedBox(width: 8),
                          Text('Crear cotización'),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Convierte lo tecleado a double (acepta coma o punto). `null` si vacío.
  static double? _parse(String v) {
    final t = v.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }
}
