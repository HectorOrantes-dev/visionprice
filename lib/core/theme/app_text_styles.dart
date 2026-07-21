import 'package:flutter/material.dart';

/// Tipografía de titulares del rediseño VisionPrice: Hanken Grotesk (700-800),
/// reservada para títulos de pantalla, montos y CTAs destacados. El cuerpo de
/// texto sigue usando Inter (fontFamily por defecto del [ThemeData]).
///
/// Ambas son fuentes VARIABLES empaquetadas como asset local (`assets/fonts/`,
/// ver `pubspec.yaml`) — antes se cargaban con `google_fonts`, que las
/// descarga de internet la primera vez que se usan; si esa descarga es lenta
/// o falla, cada pantalla que use la fuente puede generar un jank de layout.
/// Al empaquetarlas localmente, el peso correcto se interpola en el momento
/// (son variables) sin depender de la red.
abstract final class AppTextStyles {
  static TextStyle heading({
    double size = 24,
    FontWeight weight = FontWeight.w800,
    Color? color,
    double letterSpacing = -0.3,
  }) =>
      TextStyle(
        fontFamily: 'HankenGrotesk',
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );
}
