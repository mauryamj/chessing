import 'package:flutter_test/flutter_test.dart';
import 'package:chessing/core/pgn/pgn_parser.dart';

void main() {
  group('PgnParser tests', () {
    test('should parse moves from a standard PGN string', () {
      const pgn = '''
[Event "Fischer - Spassky World Championship Match"]
[Site "Reykjavik ISL"]
[Date "1972.07.23"]
[Round "6"]
[White "Robert James Fischer"]
[Black "Boris Spassky"]
[Result "1-0"]

1. c4 e6 2. Nf3 d5 3. d4 Nf6 4. Nc3 Be7 5. Bg5 O-O 6. e3 h6 7. Bh4 b6 1-0
''';
      final moves = PgnParser.parseMoves(pgn);
      expect(moves, [
        'c4', 'e6',
        'Nf3', 'd5',
        'd4', 'Nf6',
        'Nc3', 'Be7',
        'Bg5', 'O-O',
        'e3', 'h6',
        'Bh4', 'b6'
      ]);
    });

    test('should handle inline move numbers and clean comments', () {
      const pgn = '1. e4 {Best by test} e5 2. Nf3 Nc6 3. Bb5 a6 (3... Nf6 4. O-O) 4. Ba4 *';
      final moves = PgnParser.parseMoves(pgn);
      expect(moves, ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6', 'Ba4']);
    });
  });
}
