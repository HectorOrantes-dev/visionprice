import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../domain/entities/producto_entity.dart';
import '../providers/cotizacion_wizard_provider.dart';
import 'kit_section.dart';
import 'material_header.dart';
import 'metodo_chip.dart';
import 'producto_picker.dart';

/// Cuerpo de la pantalla KIT: secciones para el producto principal, el
/// método de crucetas, y un selector por cada complemento de la regla.
///
/// Antes el privado `_KitBody`.
class KitBody extends ConsumerWidget {
  final int proyectoId;
  final int index;
  const KitBody({super.key, required this.proyectoId, required this.index});

  static const _metodos = [
    ('interseccion', 'Intersección'),
    ('tradicional', 'Tradicional'),
    ('nivelacion', 'Nivelación'),
  ];

  static const _complementoInfo = {
    'pegazulejo': ('Pegazulejo', 'pegazulejo'),
    'adhesivo': ('Pegazulejo', 'pegazulejo'),
    'cruceta': ('Crucetas', 'cruceta'),
    'boquilla': ('Boquilla', 'boquilla'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(cotizacionWizardProvider(proyectoId));
    final notifier = ref.read(cotizacionWizardProvider(proyectoId).notifier);
    final sup = wizard.superficies[index];
    final regla = wizard.reglaDe(index);
    final kit = wizard.seleccionKit[index];

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            children: [
              KitSection(
                titulo: 'Loseta / piso principal',
                producto: kit?.principal,
                onTap: () => _elegirComplemento(
                  context,
                  categoria: sup.categoria,
                  seleccionado: kit?.principal,
                  onConfirm: (p) => notifier.seleccionarKitPrincipal(index, p),
                ),
              ),
              const SizedBox(height: 18),
              Text('MÉTODO DE INSTALACIÓN',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textSecondary,
                      letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final (valor, label) in _metodos) ...[
                    Expanded(
                      child: MetodoChip(
                        label: label,
                        selected: (kit?.metodo ?? 'tradicional') == valor,
                        onTap: () => notifier.seleccionarKitMetodo(index, valor),
                      ),
                    ),
                    if (valor != _metodos.last.$1) const SizedBox(width: 8),
                  ],
                ],
              ),
              for (final comp in regla.complementos) ...[
                if (_complementoInfo[comp] case (final label, final categoria)) ...[
                  const SizedBox(height: 18),
                  KitSection(
                    titulo: label,
                    producto: switch (categoria) {
                      'pegazulejo' => kit?.adhesivo,
                      'cruceta' => kit?.cruceta,
                      'boquilla' => kit?.boquilla,
                      _ => null,
                    },
                    onTap: () => _elegirComplemento(
                      context,
                      categoria: categoria,
                      seleccionado: switch (categoria) {
                        'pegazulejo' => kit?.adhesivo,
                        'cruceta' => kit?.cruceta,
                        'boquilla' => kit?.boquilla,
                        _ => null,
                      },
                      onConfirm: (p) => switch (categoria) {
                        'pegazulejo' => notifier.seleccionarKitAdhesivo(index, p),
                        'cruceta' => notifier.seleccionarKitCruceta(index, p),
                        'boquilla' => notifier.seleccionarKitBoquilla(index, p),
                        _ => null,
                      },
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: GradientButton(
            height: 52,
            onPressed: wizard.superficieCompleta(index) ? () => Navigator.pop(context) : null,
            child: Text('Confirmar kit (${_camposListos(kit, regla)} de ${1 + regla.complementos.length})'),
          ),
        ),
      ],
    );
  }

  int _camposListos(kit, regla) {
    if (kit == null) return 0;
    var n = kit.principal != null ? 1 : 0;
    for (final comp in regla.complementos) {
      switch (comp) {
        case 'pegazulejo':
        case 'adhesivo':
          if (kit.adhesivo != null) n++;
        case 'cruceta':
          if (kit.cruceta != null) n++;
        case 'boquilla':
          if (kit.boquilla != null) n++;
      }
    }
    return n;
  }

  void _elegirComplemento(
    BuildContext context, {
    required String categoria,
    required ProductoEntity? seleccionado,
    required ValueChanged<ProductoEntity> onConfirm,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: context.colors.background,
          body: SafeArea(
            child: Column(
              children: [
                MaterialHeader(titulo: 'Elegir $categoria', subtitulo: ''),
                Expanded(
                  child: ProductoPicker(
                    categoria: categoria,
                    seleccionado: seleccionado,
                    onConfirm: (p) {
                      onConfirm(p);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
