import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../domain/entities/linea_borrador_entity.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/entities/superficie_borrador_entity.dart';
import '../providers/borrador_cotizacion_provider.dart';
import '../widgets/producto_picker.dart';
import 'cotizacion_lista_screen.dart';

/// Orden fijo en que se muestran los roles de una superficie KIT
/// (piso/azulejo/zoclo): principal siempre arriba, luego los complementos.
const _ordenRolesKit = ['principal', 'adhesivo', 'cruceta', 'boquilla'];

const _labelRol = {
  'principal': 'Principal',
  'adhesivo': 'Pegazulejo',
  'cruceta': 'Crucetas',
  'boquilla': 'Emboquillado',
  'material': 'Material',
};

/// "Borrador de cotización": el resultado de `POST /cotizaciones/borrador` —
/// superficies detectadas por el ML con producto+proveedor ya auto-elegido
/// (el más barato cercano) por línea. El usuario puede cambiar cualquier
/// línea antes de "Confirmar", que crea la(s) cotización(es) reales.
class BorradorCotizacionScreen extends ConsumerStatefulWidget {
  final int grabacionId;
  const BorradorCotizacionScreen({super.key, required this.grabacionId});

  @override
  ConsumerState<BorradorCotizacionScreen> createState() =>
      _BorradorCotizacionScreenState();
}

class _BorradorCotizacionScreenState
    extends ConsumerState<BorradorCotizacionScreen> {
  bool _confirmando = false;

  @override
  Widget build(BuildContext context) {
    final provider = borradorCotizacionProvider(widget.grabacionId);
    final async = ref.watch(provider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Borrador de cotización',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    e is ApiException
                        ? e.message
                        : 'No se pudo generar el borrador de cotización.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.error),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(provider),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
          data: (borrador) => Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (borrador.advertencias.isNotEmpty) ...[
                      _AdvertenciasBanner(advertencias: borrador.advertencias),
                      const SizedBox(height: 16),
                    ],
                    for (var i = 0; i < borrador.superficies.length; i++) ...[
                      _SuperficieBorradorCard(
                        superficie: borrador.superficies[i],
                        onEditarLinea: (rol, producto) => ref
                            .read(provider.notifier)
                            .editarLinea(LineaRef(i, rol), producto),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total estimado',
                            style: TextStyle(
                                fontSize: 14,
                                color: context.colors.textSecondary)),
                        Text(
                          '\$${borrador.totalEstimado.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: context.colors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        height: 52,
                        onPressed: _confirmando
                            ? null
                            : () => _confirmar(context, provider),
                        child: _confirmando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Confirmar'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmar(BuildContext context, dynamic provider) async {
    setState(() => _confirmando = true);
    try {
      final creadas = await ref.read(provider.notifier).confirmar();
      if (!context.mounted) return;
      final proyectoId = ref.read(provider).value?.proyectoId;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CotizacionListaScreen(
            cotizaciones: creadas,
            proyectoId: proyectoId,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      setState(() => _confirmando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is ApiException
              ? e.message
              : 'No se pudo crear la cotización.'),
        ),
      );
    }
  }
}

class _AdvertenciasBanner extends StatelessWidget {
  final List<String> advertencias;
  const _AdvertenciasBanner({required this.advertencias});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.warningLight,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: context.colors.warning.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: context.colors.warning),
              const SizedBox(width: 8),
              Text('Pendiente antes de confirmar',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: context.colors.warning)),
            ],
          ),
          const SizedBox(height: 8),
          for (final a in advertencias)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('• $a',
                  style: TextStyle(
                      fontSize: 13, color: context.colors.textPrimary)),
            ),
        ],
      ),
    );
  }
}

class _SuperficieBorradorCard extends StatelessWidget {
  final SuperficieBorradorEntity superficie;
  final void Function(String rol, ProductoEntity producto) onEditarLinea;
  const _SuperficieBorradorCard({
    required this.superficie,
    required this.onEditarLinea,
  });

  static String _fmtArea(double a) =>
      a.truncateToDouble() == a ? a.toStringAsFixed(0) : a.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    // En KIT se respeta el orden fijo principal→complementos; en rendimiento
    // solo hay una línea ("material"), se muestra tal cual llega.
    final lineas = superficie.esKit
        ? [
            for (final rol in _ordenRolesKit)
              for (final l in superficie.lineas)
                if (l.rol == rol) l,
          ]
        : superficie.lineas;

    return Container(
      padding: const EdgeInsets.all(14),
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
              Icon(
                superficie.categoria == 'pintura' ||
                        superficie.categoria == 'impermeabilizante'
                    ? Icons.format_paint_outlined
                    : Icons.square_foot_outlined,
                color: context.colors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  superficie.descripcion.isEmpty
                      ? superficie.categoria
                      : superficie.descripcion,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: context.colors.textPrimary),
                ),
              ),
              Text('${_fmtArea(superficie.areaM2)} m²',
                  style: TextStyle(
                      fontSize: 13, color: context.colors.textSecondary)),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: context.colors.divider),
          for (final l in lineas) ...[
            const SizedBox(height: 10),
            _LineaBorradorTile(
              linea: l,
              onTap: () => _elegirOtroProducto(context, l),
            ),
          ],
        ],
      ),
    );
  }

  void _elegirOtroProducto(BuildContext context, LineaBorradorEntity l) {
    final categoria = categoriaParaRol(l.rol, superficie.categoria);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: context.colors.background,
          appBar: AppBar(
            backgroundColor: context.colors.background,
            elevation: 0,
            title: Text('Elegir ${_labelRol[l.rol] ?? l.rol}'),
          ),
          body: SafeArea(
            child: ProductoPicker(
              categoria: categoria,
              seleccionado: null,
              onConfirm: (p) {
                onEditarLinea(l.rol, p);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LineaBorradorTile extends StatelessWidget {
  final LineaBorradorEntity linea;
  final VoidCallback onTap;
  const _LineaBorradorTile({required this.linea, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(_labelRol[linea.rol] ?? linea.rol,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textSecondary)),
                      if (linea.editado) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: context.colors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('editado',
                              style: TextStyle(
                                  fontSize: 9, color: context.colors.primary)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(linea.nombre,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary)),
                  Text(
                    [
                      if (linea.proveedorNombre != null) linea.proveedorNombre!,
                      if (linea.distanciaKm != null)
                        '${linea.distanciaKm!.toStringAsFixed(1)} km',
                    ].join(' · '),
                    style:
                        TextStyle(fontSize: 11, color: context.colors.textHint),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  linea.editado
                      ? 'se recalculará'
                      : '\$${linea.subtotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontStyle:
                        linea.editado ? FontStyle.italic : FontStyle.normal,
                    color: linea.editado
                        ? context.colors.textSecondary
                        : context.colors.textPrimary,
                  ),
                ),
                Text('${linea.cantidad.toStringAsFixed(0)} ${linea.unidad}',
                    style: TextStyle(
                        fontSize: 11, color: context.colors.textHint)),
              ],
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 18, color: context.colors.textHint),
          ],
        ),
      ),
    );
  }
}
