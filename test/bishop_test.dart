import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:squares/squares.dart' as sq;

void main() {
  test('Bishop attacked squares test', () {
    final game = bishop.Game(variant: bishop.Variant.standard());
    final sqSize = sq.BoardSize.standard;
    final attackedList = <int>[];
    
    // Check which squares are attacked by black (color index 1)
    final blackColor = 1;
    
    for (int i = 0; i < 64; i++) {
      final name = sqSize.squareName(i);
      final bpSquareIndex = game.size.squareNumber(name);
      
      if (game.isAttacked(bpSquareIndex, blackColor)) {
        attackedList.add(i);
      }
    }
    
    debugPrint('Attacked squares count by Black: ${attackedList.length}');
    debugPrint('Attacked squares names: ${attackedList.map((i) => sqSize.squareName(i)).toList()}');
  });
}
