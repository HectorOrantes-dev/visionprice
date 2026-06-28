import 'package:flutter/material.dart';

/// VisionPrice Color Palette
/// Minimalista, alto contraste, legible bajo luz solar
abstract final class AppColors {
  // === Brand ===
  static const primary = Color(0xFF2E5BFF); // Azul vibrante
  static const primaryDark = Color(0xFF1B3FC2);
  static const primaryLight = Color(0xFF6B8BFF);
  static const accent = Color(0xFFF59E0B); // Naranja/Ambar para alertas

  // === Backgrounds ===
  static const bgDark = Color(0xFFF8F9FB); // Gris/blanco muy claro para fondo general
  static const bgCard = Color(0xFFFFFFFF); // Blanco puro
  static const bgElevated = Color(0xFFFFFFFF); // Blanco
  static const bgScrim = Color(0x66000000); // Modal overlay
  static const background = bgDark;
  static const surface = bgCard;
  static const surfaceVariant = bgElevated;

  // === Text ===
  static const textPrimary = Color(0xFF111827); // Casi negro
  static const textSecondary = Color(0xFF6B7280); // Gris medio
  static const textHint = Color(0xFF9CA3AF); // Gris claro
  static const textOnPrimary = Color(0xFFFFFFFF); // Texto sobre botones azules

  // === Status ===
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);
  static const successLight = Color(0x2210B981);
  static const warningLight = Color(0x22F59E0B);
  static const errorLight = Color(0x22EF4444);
  static const recordingRed = Color(0xFFEF4444);

  // === Surfaces ===
  static const divider = Color(0xFFF3F4F6);
  static const border = Color(0xFFE5E7EB);
  static const shadow = Color(0x1A000000); // Sombra más sutil y oscura

  // === Suppliers ===
  static const homeDepot = Color(0xFFF96302);
  static const sodimac = Color(0xFF0066CC);
  static const construrama = Color(0xFF00A550);

  // === Gradients ===
  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4B74FF), Color(0xFF2E5BFF)],
  );

  static const gradientBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF8F9FB), Color(0xFFF3F4F6)],
  );

  static const gradientCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
  );

  static const gradientScanner = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x002E5BFF), Color(0x402E5BFF)],
  );
}
