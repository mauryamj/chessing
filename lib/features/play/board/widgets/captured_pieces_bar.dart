import 'package:flutter/material.dart';

class CapturedPiecesBar extends StatelessWidget {
  final List<String> boardSymbols;
  final bool forWhite; // if true, show pieces captured by White (i.e. black pieces)

  const CapturedPiecesBar({
    super.key,
    required this.boardSymbols,
    required this.forWhite,
  });

  Map<String, int> _calculateCaptured() {
    final standardWhite = {'P': 8, 'N': 2, 'B': 2, 'R': 2, 'Q': 1};
    final standardBlack = {'p': 8, 'n': 2, 'b': 2, 'r': 2, 'q': 1};

    final counts = <String, int>{};
    for (final sym in boardSymbols) {
      if (sym.isNotEmpty) {
        counts[sym] = (counts[sym] ?? 0) + 1;
      }
    }

    final captured = <String, int>{};
    final targetSet = forWhite ? standardBlack : standardWhite;

    targetSet.forEach((key, standardCount) {
      final activeCount = counts[key] ?? 0;
      final diff = standardCount - activeCount;
      if (diff > 0) {
        captured[key] = diff;
      }
    });

    return captured;
  }

  String _getUnicodePiece(String symbol) {
    switch (symbol.toLowerCase()) {
      case 'p': return '♟';
      case 'n': return '♞';
      case 'b': return '♝';
      case 'r': return '♜';
      case 'q': return '♛';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final captured = _calculateCaptured();
    final pieceList = <Widget>[];

    final sortOrder = forWhite ? ['q', 'r', 'b', 'n', 'p'] : ['Q', 'R', 'B', 'N', 'P'];

    for (final key in sortOrder) {
      if (captured.containsKey(key)) {
        final count = captured[key]!;
        for (int i = 0; i < count; i++) {
          pieceList.add(
            Text(
              _getUnicodePiece(key),
              style: TextStyle(
                fontSize: 16,
                color: forWhite ? Colors.black54 : Colors.grey[400],
              ),
            ),
          );
        }
      }
    }

    if (pieceList.isEmpty) {
      return const SizedBox(height: 24);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      height: 24,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: pieceList,
      ),
    );
  }
}
