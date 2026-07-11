import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Paleta completa de VisionPrice como [ThemeExtension], para soportar modo
/// claro y oscuro SIN perder ninguno de los colores propios de la app.
///
/// - [AppPalette.light]: usa EXACTAMENTE los valores de [AppColors] (mismos
///   hex) → el modo claro se ve idéntico al diseño actual, garantizado.
/// - [AppPalette.dark]: variante oscura derivada de la misma identidad de marca.
///
/// Acceso en widgets: `context.colors.textSecondary` (ver extensión abajo).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textOnPrimary;
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color error;
  final Color errorLight;
  final Color info;
  final Color border;
  final Color divider;
  final Color recordingRed;
  final Color recordingRedLight;
  final Color syncPending;
  final Color syncReady;
  final Color syncError;
  final Color syncUploading;
  final Color navBackground;
  final Color navSelected;
  final Color navUnselected;

  const AppPalette({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textOnPrimary,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.error,
    required this.errorLight,
    required this.info,
    required this.border,
    required this.divider,
    required this.recordingRed,
    required this.recordingRedLight,
    required this.syncPending,
    required this.syncReady,
    required this.syncError,
    required this.syncUploading,
    required this.navBackground,
    required this.navSelected,
    required this.navUnselected,
  });

  /// Modo CLARO: exactamente los colores actuales de la app (idéntico diseño).
  static const AppPalette light = AppPalette(
    primary: AppColors.primary,
    primaryLight: AppColors.primaryLight,
    primaryDark: AppColors.primaryDark,
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceVariant: AppColors.surfaceVariant,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textHint: AppColors.textHint,
    textOnPrimary: AppColors.textOnPrimary,
    success: AppColors.success,
    successLight: AppColors.successLight,
    warning: AppColors.warning,
    warningLight: AppColors.warningLight,
    error: AppColors.error,
    errorLight: AppColors.errorLight,
    info: AppColors.info,
    border: AppColors.border,
    divider: AppColors.divider,
    recordingRed: AppColors.recordingRed,
    recordingRedLight: AppColors.recordingRedLight,
    syncPending: AppColors.syncPending,
    syncReady: AppColors.syncReady,
    syncError: AppColors.syncError,
    syncUploading: AppColors.syncUploading,
    navBackground: AppColors.navBackground,
    navSelected: AppColors.navSelected,
    navUnselected: AppColors.navUnselected,
  );

  /// Modo OSCURO: misma identidad de marca sobre superficies slate oscuras.
  static const AppPalette dark = AppPalette(
    primary: Color(0xFF60A5FA), // azul marca, aclarado para contraste en oscuro
    primaryLight: Color(0xFF1E3A5F),
    primaryDark: Color(0xFF93C5FD),
    background: Color(0xFF0B1220),
    surface: Color(0xFF111827),
    surfaceVariant: Color(0xFF1E293B),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textHint: Color(0xFF64748B),
    textOnPrimary: Color(0xFF0B1220),
    success: Color(0xFF34D399),
    successLight: Color(0xFF064E3B),
    warning: Color(0xFFFBBF24),
    warningLight: Color(0xFF422006),
    error: Color(0xFFF87171),
    errorLight: Color(0xFF450A0A),
    info: Color(0xFF60A5FA),
    border: Color(0xFF334155),
    divider: Color(0xFF1E293B),
    recordingRed: Color(0xFFF87171),
    recordingRedLight: Color(0xFF450A0A),
    syncPending: Color(0xFFFBBF24),
    syncReady: Color(0xFF34D399),
    syncError: Color(0xFFF87171),
    syncUploading: Color(0xFF60A5FA),
    navBackground: Color(0xFF111827),
    navSelected: Color(0xFF60A5FA),
    navUnselected: Color(0xFF64748B),
  );

  @override
  AppPalette copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? textOnPrimary,
    Color? success,
    Color? successLight,
    Color? warning,
    Color? warningLight,
    Color? error,
    Color? errorLight,
    Color? info,
    Color? border,
    Color? divider,
    Color? recordingRed,
    Color? recordingRedLight,
    Color? syncPending,
    Color? syncReady,
    Color? syncError,
    Color? syncUploading,
    Color? navBackground,
    Color? navSelected,
    Color? navUnselected,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      info: info ?? this.info,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      recordingRed: recordingRed ?? this.recordingRed,
      recordingRedLight: recordingRedLight ?? this.recordingRedLight,
      syncPending: syncPending ?? this.syncPending,
      syncReady: syncReady ?? this.syncReady,
      syncError: syncError ?? this.syncError,
      syncUploading: syncUploading ?? this.syncUploading,
      navBackground: navBackground ?? this.navBackground,
      navSelected: navSelected ?? this.navSelected,
      navUnselected: navUnselected ?? this.navUnselected,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      primary: c(primary, other.primary),
      primaryLight: c(primaryLight, other.primaryLight),
      primaryDark: c(primaryDark, other.primaryDark),
      background: c(background, other.background),
      surface: c(surface, other.surface),
      surfaceVariant: c(surfaceVariant, other.surfaceVariant),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textHint: c(textHint, other.textHint),
      textOnPrimary: c(textOnPrimary, other.textOnPrimary),
      success: c(success, other.success),
      successLight: c(successLight, other.successLight),
      warning: c(warning, other.warning),
      warningLight: c(warningLight, other.warningLight),
      error: c(error, other.error),
      errorLight: c(errorLight, other.errorLight),
      info: c(info, other.info),
      border: c(border, other.border),
      divider: c(divider, other.divider),
      recordingRed: c(recordingRed, other.recordingRed),
      recordingRedLight: c(recordingRedLight, other.recordingRedLight),
      syncPending: c(syncPending, other.syncPending),
      syncReady: c(syncReady, other.syncReady),
      syncError: c(syncError, other.syncError),
      syncUploading: c(syncUploading, other.syncUploading),
      navBackground: c(navBackground, other.navBackground),
      navSelected: c(navSelected, other.navSelected),
      navUnselected: c(navUnselected, other.navUnselected),
    );
  }
}

/// Acceso ergonómico a la paleta desde cualquier widget: `context.colors.xxx`.
/// En modo claro devuelve exactamente los colores actuales; en oscuro, la
/// variante oscura.
extension AppPaletteX on BuildContext {
  AppPalette get colors =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
