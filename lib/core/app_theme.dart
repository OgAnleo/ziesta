import 'package:flutter/material.dart';

class AppTheme {
  static const _seed = Color(0xFF1E3A8A);
  static const _background = Color(0xFF04060C);
  static const _text = Color(0xFFE6E9F2);
  static const _muted = Color(0xFF8A93A8);
  static const _accent = Color(0xFF8FA4F0);
  static const _outline = Color(0xFF232B45);

  static ThemeData dark() => _build(
    ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      primary: _accent,
      onPrimary: _background,
      surface: _background,
      onSurface: _text,
      onSurfaceVariant: _muted,
      outline: _outline,
    ),
  );

  static ThemeData light() => _build(ColorScheme.fromSeed(seedColor: _seed));

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);

    final textTheme = base.textTheme
        .copyWith(
          displayLarge: base.textTheme.displayLarge?.copyWith(
            fontSize: 88,
            fontWeight: FontWeight.w200,
            letterSpacing: -1,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w300,
          ),
          titleLarge: base.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w300,
          ),
          labelLarge: base.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onSurfaceVariant,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          letterSpacing: 4,
          color: scheme.onSurfaceVariant,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: BorderSide(color: scheme.outline),
          foregroundColor: scheme.onSurfaceVariant,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
      ),
    );
  }
}
