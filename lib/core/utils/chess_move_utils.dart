import 'package:bishop/bishop.dart' as bishop;

class ChessMoveUtils {
  static String toUci(bishop.Game game, bishop.Move m) {
    final fromStr = game.size.squareName(m.from);
    final toStr = game.size.squareName(m.to);
    String promoStr = '';
    if (m.promotion && m.promoPiece != null) {
      switch (m.promoPiece) {
        case 2:
          promoStr = 'n';
          break;
        case 3:
          promoStr = 'b';
          break;
        case 4:
          promoStr = 'r';
          break;
        case 5:
          promoStr = 'q';
          break;
      }
    }
    return '$fromStr$toStr$promoStr';
  }
}
