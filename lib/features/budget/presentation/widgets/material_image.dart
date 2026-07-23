import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Espacio de imagen para un material/producto que llega del back-end
/// (`image_url` de `GET /cotizaciones/productos`).
///
/// - Si [url] es `null`/vacío → muestra un recuadro con [fallbackIcon] (no todos
///   los productos traen foto).
/// - Mientras carga → recuadro con spinner.
/// - Si la URL falla → recuadro con ícono de imagen rota.
///
/// Usa `cacheWidth`/`cacheHeight` para que el engine decodifique la imagen ya
/// REDIMENSIONADA (fuera del hilo de UI): una foto pesada del material no infla
/// la memoria ni causa jank al listar materiales.
class MaterialImage extends StatelessWidget {
  final String? url;
  final double size;
  final double radius;
  final IconData fallbackIcon;

  const MaterialImage({
    super.key,
    required this.url,
    this.size = 52,
    this.radius = 12,
    this.fallbackIcon = Icons.inventory_2_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final u = url;

    if (u == null || u.trim().isEmpty) {
      return _box(
        context,
        child: Icon(fallbackIcon,
            color: context.colors.primary, size: size * 0.42),
        color: context.colors.primaryLight,
        borderRadius: borderRadius,
      );
    }

    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cache = (size * dpr).round(); // resolución real del dispositivo
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        u,
        width: size,
        height: size,
        fit: BoxFit.cover,
        cacheWidth: cache,
        cacheHeight: cache,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _box(
            context,
            color: context.colors.surfaceVariant,
            borderRadius: borderRadius,
            child: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stack) => _box(
          context,
          color: context.colors.surfaceVariant,
          borderRadius: borderRadius,
          child: Icon(Icons.broken_image_outlined,
              size: size * 0.4, color: context.colors.textSecondary),
        ),
      ),
    );
  }

  Widget _box(
    BuildContext context, {
    required Widget child,
    required Color color,
    required BorderRadius borderRadius,
  }) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      child: child,
    );
  }
}
