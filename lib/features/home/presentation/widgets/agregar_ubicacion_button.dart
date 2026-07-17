import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/home_provider.dart';

/// Aviso + acción para las obras creadas **sin ubicación**: toma la posición
/// actual y la manda con `PATCH /proyectos/{id}`. Sin coordenadas, la obra no
/// entra al dataset real de recomendaciones.
class AgregarUbicacionButton extends ConsumerStatefulWidget {
  final int proyectoId;
  const AgregarUbicacionButton({super.key, required this.proyectoId});

  @override
  ConsumerState<AgregarUbicacionButton> createState() =>
      _AgregarUbicacionButtonState();
}

class _AgregarUbicacionButtonState
    extends ConsumerState<AgregarUbicacionButton> {
  bool _guardando = false;

  Future<void> _agregar() async {
    setState(() => _guardando = true);
    var ok = false;
    try {
      ok = await ref
          .read(homeProvider.notifier)
          .completarUbicacion(widget.proyectoId);
    } catch (_) {
      ok = false;
    }
    if (!mounted) return;
    setState(() => _guardando = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
          ? 'Ubicación guardada'
          : 'No se pudo obtener tu ubicación. Revisa el GPS y los permisos.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: _guardando ? null : _agregar,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_guardando)
              const SizedBox(
                width: 11,
                height: 11,
                child: CircularProgressIndicator(strokeWidth: 1.6),
              )
            else
              Icon(Icons.add_location_alt_outlined, size: 13, color: c.warning),
            const SizedBox(width: 4),
            Text(
              _guardando ? 'Guardando…' : 'Sin ubicación · Agregar',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: c.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
