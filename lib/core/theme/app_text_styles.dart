import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tipografía de titulares del rediseño VisionPrice: Hanken Grotesk (700-800),
/// reservada para títulos de pantalla, montos y CTAs destacados. El cuerpo de
/// texto sigue usando Inter (fontFamily por defecto del [ThemeData]).
abstract final class AppTextStyles {
  static TextStyle heading({
    double size = 24,
    FontWeight weight = FontWeight.w800,
    Color? color,
    double letterSpacing = -0.3,
  }) =>
      GoogleFonts.hankenGrotesk(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );
}
