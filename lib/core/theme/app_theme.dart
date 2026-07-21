import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_palette.dart';

abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF1E3A8A);
  static const primaryLight = Color(0xFFEFF6FF);
  static const primaryDark = Color(0xFF16295E);

  // Gradiente de marca (CTAs destacados: botones principales, hero cards)
  static const gradientStart = Color(0xFF1E3A8A);
  static const gradientEnd = Color(0xFF2F5BD9);

  // Background
  static const background = Color(0xFFF1F5F9);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF8FAFC);

  // Text
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textHint = Color(0xFF94A3B8);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // Status
  static const success = Color(0xFF10B981);
  static const successLight = Color(0xFFD1FAE5);
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEE2E2);
  static const info = Color(0xFF3B82F6);

  // Borders & Dividers
  static const border = Color(0xFFE2E8F0);
  static const divider = Color(0xFFF1F5F9);

  // Recording
  static const recordingRed = Color(0xFFEF4444);
  static const recordingRedLight = Color(0xFFFEE2E2);

  // Sync states
  static const syncPending = Color(0xFFF59E0B);
  static const syncReady = Color(0xFF10B981);
  static const syncError = Color(0xFFEF4444);
  static const syncUploading = Color(0xFF2563EB);

  // Bottom nav
  static const navBackground = Color(0xFFFFFFFF);
  static const navSelected = Color(0xFF2563EB);
  static const navUnselected = Color(0xFF94A3B8);
}

class AppTheme {
  /// Tema CLARO: construido desde [AppPalette.light] (= [AppColors] exactos),
  /// por lo que se ve idéntico al diseño actual.
  static ThemeData get light => _build(AppPalette.light, _lightScheme);

  /// Tema OSCURO: misma estructura, paleta [AppPalette.dark].
  static ThemeData get dark => _build(AppPalette.dark, _darkScheme);

  static const ColorScheme _lightScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.textSecondary,
    error: AppColors.error,
    onError: Colors.white,
    outline: AppColors.border,
  );

  static const ColorScheme _darkScheme = ColorScheme.dark(
    primary: Color(0xFF60A5FA),
    onPrimary: Color(0xFF0B1220),
    primaryContainer: Color(0xFF1E3A5F),
    onPrimaryContainer: Color(0xFF93C5FD),
    surface: Color(0xFF111827),
    onSurface: Color(0xFFF1F5F9),
    surfaceContainerHighest: Color(0xFF1E293B),
    onSurfaceVariant: Color(0xFF94A3B8),
    error: Color(0xFFF87171),
    onError: Color(0xFF0B1220),
    outline: Color(0xFF334155),
  );

  /// Construye el [ThemeData] a partir de una paleta. Al derivar los colores de
  /// los componentes de [p], el modo claro (con [AppPalette.light]) reproduce
  /// exactamente el diseño actual y el oscuro reutiliza la misma estructura.
  static ThemeData _build(AppPalette p, ColorScheme scheme) => ThemeData(
        useMaterial3: true,
        brightness: scheme.brightness,
        fontFamily: 'Inter',
        colorScheme: scheme,
        extensions: [p],
        scaffoldBackgroundColor: p.background,
        appBarTheme: AppBarTheme(
          backgroundColor: p.surface,
          foregroundColor: p.textPrimary,
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: scheme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
          ),
          iconTheme: IconThemeData(color: p.textPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: p.primary,
            foregroundColor: p.textOnPrimary,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: p.textPrimary,
            side: BorderSide(color: p.border),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: p.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: p.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: p.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: p.primary, width: 1.5),
          ),
          hintStyle: TextStyle(
            color: p.textHint,
            fontSize: 15,
          ),
        ),
        cardTheme: CardThemeData(
          color: p.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: p.border, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        dividerTheme: DividerThemeData(
          color: p.divider,
          thickness: 1,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return p.primary;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: BorderSide(color: p.border, width: 1.5),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: p.navBackground,
          indicatorColor: p.primaryLight,
          elevation: 3,
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? p.navSelected : p.navUnselected,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 24,
              color: selected ? p.navSelected : p.navUnselected,
            );
          }),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return p.textHint;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return p.primary;
            }
            return p.border;
          }),
        ),
      );
}
