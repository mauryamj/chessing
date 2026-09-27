import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squares/squares.dart' as sq;
import '../../app/theme.dart';
import '../../features/settings/settings_provider.dart';

class BoardThemeBuilder {
  static sq.BoardTheme build(BuildContext context, WidgetRef ref) {
    final boardThemeType = ref.watch(boardThemeTypeProvider);
    return fromThemeType(context, boardThemeType);
  }

  static sq.BoardTheme fromThemeType(BuildContext context, BoardThemeType boardThemeType) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ChessBoardTheme ext;
    switch (boardThemeType) {
      case BoardThemeType.wood:
        ext = isDark ? ChessBoardTheme.woodDark : ChessBoardTheme.woodLight;
        break;
      case BoardThemeType.neon:
        ext = isDark ? ChessBoardTheme.neonDark : ChessBoardTheme.neonLight;
        break;
      case BoardThemeType.minimal:
        ext = isDark ? ChessBoardTheme.minimalDark : ChessBoardTheme.minimalLight;
        break;
      case BoardThemeType.classic:
        ext = Theme.of(context).extension<ChessBoardTheme>() ??
            (isDark ? ChessBoardTheme.classicDark : ChessBoardTheme.classicLight);
        break;
    }
    return sq.BoardTheme(
      lightSquare: ext.lightSquareColor,
      darkSquare: ext.darkSquareColor,
      check: ext.checkSquareColor,
      checkmate: Colors.orange,
      previous: ext.lastMoveDestColor,
      selected: ext.selectedSquareColor,
      premove: const Color(0x807B56B3),
    );
  }
}

sq.BoardTheme getBoardTheme(BuildContext context, WidgetRef ref) =>
    BoardThemeBuilder.build(context, ref);
