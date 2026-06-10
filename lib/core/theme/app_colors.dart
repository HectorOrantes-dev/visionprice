import 'package:flutter/material.dart';

/// VisionPrice Color Palette
/// Minimalista, alto contraste, legible bajo luz solar
abstract final class AppColors {
  // === Brand ===
  static const primary = Color(0xFF00E5A0); // Verde esmeralda brillante
  static const primaryDark = Color(0xFF00B37E);
  static const primaryLight = Color(0xFF4DFFBE);
  static const accent = Color(0xFF00D4FF); // Cyan eléctrico para AR overlay

  // === Backgrounds ===
  static const bgDark = Color(0xFF0A0D12); // Negro azulado profundo
  static const bgCard = Color(0xFF141920); // Card surface
  static const bgElevated = Color(0xFF1C2330); // Elevated surface
  static const bgScrim = Color(0x99000000); // Modal overlay

  // === Text ===
  static const textPrimary = Color(0xFFF0F4FF);
  static const textSecondary = Color(0xFF8A95A8);
  static const textHint = Color(0xFF4A5568);
  static const textOnPrimary = Color(0xFF0A0D12);

  // === Status ===
  static const success = Color(0xFF00E5A0);
  static const warning = Color(0xFFFFB400);
  static const error = Color(0xFFFF4D6A);
  static const info = Color(0xFF00D4FF);

  // === Surfaces ===
  static const divider = Color(0xFF1E2940);
  static const border = Color(0xFF2A3550);
  static const shadow = Color(0x4000E5A0);

  // === Suppliers ===
  static const homeDepot = Color(0xFFF96302);
  static const sodimac = Color(0xFF0066CC);
  static const construrama = Color(0xFF00A550);

  // === Gradients ===
  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const gradientBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D1117), Color(0xFF0A0D12)],
  );

  static const gradientCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2235), Color(0xFF141920)],
  );

  static const gradientScanner = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x0000E5A0), Color(0x4000E5A0)],
  );
}
