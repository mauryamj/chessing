import 'package:flutter/material.dart';

class MaterialDiffBar extends StatelessWidget {
  final List<String> boardSymbols;
  final bool forWhite; // if true, show from White's perspective (+ means White is leading)

  const MaterialDiffBar({
    super.key,
    required this.boardSymbols,
    required this.forWhite,
  });

  int _calculateScore() {
    final values = {
      'P': 1, 'N': 3, 'B': 3, 'R': 5, 'Q': 9,
      'p': -1, 'n': -3, 'b': -3, 'r': -5, 'q': -9
    };

    int score = 0;
    for (final sym in boardSymbols) {
      if (sym.isNotEmpty && values.containsKey(sym)) {
        score += values[sym]!;
      }
    }

    return forWhite ? score : -score;
  }

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore();
    if (score == 0) {
      return const SizedBox.shrink();
    }

    final isLeading = score > 0;
    final text = isLeading ? '+$score' : '$score';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isLeading 
            ? Colors.green.withValues(alpha: 0.1) 
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isLeading ? Colors.green[700] : Colors.red[700],
        ),
      ),
    );
  }
}
