import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'status_colors.dart';

abstract final class AppTheme {
  static const fontFamily = 'PlusJakartaSans';
  static const seed = Color(0xFF4F46E5);
  static const accent = Color(0xFF7C3AED);

  /// Gradiente usado nos elementos de destaque (splash, card de sincronização).
  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4338CA), Color(0xFF6D28D9), Color(0xFF8B5CF6)],
  );

  static const radiusSm = 12.0;
  static const radiusMd = 16.0;
  static const radiusLg = 20.0;
  static const radiusXl = 28.0;

  static ThemeData get light => _build(
    Brightness.light,
    scaffold: const Color(0xFFF5F6FA),
    surface: Colors.white,
    input: const Color(0xFFF1F2F7),
    status: StatusColors.light,
  );

  static ThemeData get dark => _build(
    Brightness.dark,
    scaffold: const Color(0xFF0F1117),
    surface: const Color(0xFF181B24),
    input: const Color(0xFF212532),
    status: StatusColors.dark,
  );

  static ThemeData _build(
    Brightness brightness, {
    required Color scaffold,
    required Color surface,
    required Color input,
    required StatusColors status,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: seed,
          brightness: brightness,
          // Mantém o indigo vivo (o tonalSpot padrão dessatura a cor).
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ).copyWith(
          surface: surface,
          surfaceContainerLowest: surface,
          surfaceContainerLow: surface,
          error: status.danger,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,
    );

    // base.textTheme não traz tamanhos (a geometria só é aplicada em Theme.of);
    // mescla aqui para que os estilos usados nos sub-temas (AppBar, diálogos) tenham fontSize.
    final geometry = Typography.englishLike2021.merge(base.textTheme);
    final text = geometry.copyWith(
      displaySmall: geometry.displaySmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1),
      headlineMedium: geometry.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.8),
      headlineSmall: geometry.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      titleLarge: geometry.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
      titleMedium: geometry.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      titleSmall: geometry.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: geometry.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: geometry.bodyMedium?.copyWith(height: 1.4),
    );

    final hairline = scheme.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.6);
    const buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radiusMd)));
    const buttonSize = Size.fromHeight(56);
    final buttonText = text.labelLarge?.copyWith(fontSize: 15);

    // Campo preenchido com label interno; no foco/erro aparece só a barra inferior arredondada.
    UnderlineInputBorder inputBorder([Color color = Colors.transparent, double width = 0]) => UnderlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: width == 0 ? BorderSide.none : BorderSide(color: color, width: width),
    );

    return base.copyWith(
      scaffoldBackgroundColor: scaffold,
      textTheme: text,
      extensions: [status],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarThemeData(
        backgroundColor: scaffold,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: hairline),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: input,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: inputBorder(),
        enabledBorder: inputBorder(),
        focusedBorder: inputBorder(scheme.primary, 2.4),
        errorBorder: inputBorder(status.danger, 1.6),
        focusedErrorBorder: inputBorder(status.danger, 2.4),
        prefixIconColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.focused) ? scheme.primary : scheme.onSurfaceVariant,
        ),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.error) ? status.danger : scheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant.withValues(alpha: 0.7)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: buttonText,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: buttonText,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 4,
        highlightElevation: 6,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radiusLg))),
        extendedTextStyle: buttonText,
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: hairline),
        labelStyle: text.labelLarge,
        backgroundColor: surface,
        selectedColor: scheme.primaryContainer,
        showCheckmark: false,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: scheme.outlineVariant,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radiusXl))),
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF2A2F3D) : const Color(0xFF1E1B4B),
        contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        actionTextColor: const Color(0xFFC4B5FD),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radiusMd))),
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
      dividerTheme: DividerThemeData(color: hairline, thickness: 1, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.primary.withValues(alpha: 0.12),
      ),
    );
  }
}
