import 'package:flutter/material.dart';

class ChessBoardTheme extends ThemeExtension<ChessBoardTheme> {
  final Color lightSquareColor;
  final Color darkSquareColor;
  final Color selectedSquareColor;
  final Color checkSquareColor;
  final Color lastMoveSourceColor;
  final Color lastMoveDestColor;
  final Color threatSquareColor;
  final Color legalMoveDotColor;

  ChessBoardTheme({
    required this.lightSquareColor,
    required this.darkSquareColor,
    required this.selectedSquareColor,
    required this.checkSquareColor,
    required this.lastMoveSourceColor,
    required this.lastMoveDestColor,
    required this.threatSquareColor,
    required this.legalMoveDotColor,
  });

  @override
  ThemeExtension<ChessBoardTheme> copyWith({
    Color? lightSquareColor,
    Color? darkSquareColor,
    Color? selectedSquareColor,
    Color? checkSquareColor,
    Color? lastMoveSourceColor,
    Color? lastMoveDestColor,
    Color? threatSquareColor,
    Color? legalMoveDotColor,
  }) {
    return ChessBoardTheme(
      lightSquareColor: lightSquareColor ?? this.lightSquareColor,
      darkSquareColor: darkSquareColor ?? this.darkSquareColor,
      selectedSquareColor: selectedSquareColor ?? this.selectedSquareColor,
      checkSquareColor: checkSquareColor ?? this.checkSquareColor,
      lastMoveSourceColor: lastMoveSourceColor ?? this.lastMoveSourceColor,
      lastMoveDestColor: lastMoveDestColor ?? this.lastMoveDestColor,
      threatSquareColor: threatSquareColor ?? this.threatSquareColor,
      legalMoveDotColor: legalMoveDotColor ?? this.legalMoveDotColor,
    );
  }

  @override
  ThemeExtension<ChessBoardTheme> lerp(
    covariant ThemeExtension<ChessBoardTheme>? other,
    double t,
  ) {
    if (other is! ChessBoardTheme) {
      return this;
    }
    return ChessBoardTheme(
      lightSquareColor: Color.lerp(lightSquareColor, other.lightSquareColor, t)!,
      darkSquareColor: Color.lerp(darkSquareColor, other.darkSquareColor, t)!,
      selectedSquareColor: Color.lerp(selectedSquareColor, other.selectedSquareColor, t)!,
      checkSquareColor: Color.lerp(checkSquareColor, other.checkSquareColor, t)!,
      lastMoveSourceColor: Color.lerp(lastMoveSourceColor, other.lastMoveSourceColor, t)!,
      lastMoveDestColor: Color.lerp(lastMoveDestColor, other.lastMoveDestColor, t)!,
      threatSquareColor: Color.lerp(threatSquareColor, other.threatSquareColor, t)!,
      legalMoveDotColor: Color.lerp(legalMoveDotColor, other.legalMoveDotColor, t)!,
    );
  }

  // Classic themes
  static final classicLight = ChessBoardTheme(
    lightSquareColor: const Color(0xFFF0D9B5),
    darkSquareColor: const Color(0xFFB58863),
    selectedSquareColor: const Color(0x80BAC141),
    checkSquareColor: const Color(0xFFEB5757),
    lastMoveSourceColor: const Color(0x60BAC141),
    lastMoveDestColor: const Color(0x80BAC141),
    threatSquareColor: const Color(0x4DFF0000),
    legalMoveDotColor: const Color(0x40000000),
  );

  static final classicDark = ChessBoardTheme(
    lightSquareColor: const Color(0xFFECECD7),
    darkSquareColor: const Color(0xFF739552),
    selectedSquareColor: const Color(0x80F7EC74),
    checkSquareColor: const Color(0xFFC93B2B),
    lastMoveSourceColor: const Color(0x60F7EC74),
    lastMoveDestColor: const Color(0x80F7EC74),
    threatSquareColor: const Color(0x4DFF0000),
    legalMoveDotColor: const Color(0x40FFFFFF),
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFB58863),
        brightness: Brightness.light,
        surface: const Color(0xFFF9F7F4),
        primary: const Color(0xFF8B5E3C),
        secondary: const Color(0xFF739552),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 1,
      ),
      extensions: [ChessBoardTheme.classicLight],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF739552),
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1E1E),
        primary: const Color(0xFFB58863),
        secondary: const Color(0xFFECECD7),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF2C2C2C),
        elevation: 1,
      ),
      extensions: [ChessBoardTheme.classicDark],
    );
  }
}
