import 'package:flutter/material.dart';

/// The palette of a real okey table: dark felt, ivory tiles, brass accents.
abstract final class OkeyPalette {
  static const Color feltDark = Color(0xFF0F3D2E);
  static const Color felt = Color(0xFF14523B);
  static const Color feltLight = Color(0xFF1B6B4C);
  static const Color ivory = Color(0xFFFBF5E6);
  static const Color ivoryShade = Color(0xFFE4D6B4);
  static const Color brass = Color(0xFFD4A24C);
  static const Color rack = Color(0xFF4E342E);
  static const Color rackLight = Color(0xFF6D4C41);

  static const Color tileRed = Color(0xFFC62828);
  static const Color tileYellow = Color(0xFFE09E12);
  static const Color tileBlack = Color(0xFF212121);
  static const Color tileBlue = Color(0xFF1565C0);

  static const Color danger = Color(0xFFD84343);
  static const Color success = Color(0xFF4CAF7D);
}

ThemeData buildOkeyTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: OkeyPalette.felt,
    brightness: Brightness.dark,
  ).copyWith(
    primary: OkeyPalette.brass,
    onPrimary: OkeyPalette.feltDark,
    secondary: OkeyPalette.feltLight,
    surface: OkeyPalette.feltDark,
    onSurface: OkeyPalette.ivory,
    error: OkeyPalette.danger,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: OkeyPalette.feltDark,
    canvasColor: OkeyPalette.feltDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: OkeyPalette.ivory,
    ),
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: OkeyPalette.ivory,
      displayColor: OkeyPalette.ivory,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0x33FBF5E6),
      space: 1,
      thickness: 1,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        // 44 CSS pixels is the minimum comfortable touch target on a phone.
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(88, 48),
        foregroundColor: OkeyPalette.ivory,
        side: const BorderSide(color: Color(0x66FBF5E6)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(64, 44),
        foregroundColor: OkeyPalette.brass,
      ),
    ),
    cardTheme: CardThemeData(
      color: OkeyPalette.felt,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: OkeyPalette.brass,
      textColor: OkeyPalette.ivory,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: OkeyPalette.rack,
      contentTextStyle: const TextStyle(color: OkeyPalette.ivory),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? OkeyPalette.brass
            : OkeyPalette.ivoryShade,
      ),
    ),
  );
}
