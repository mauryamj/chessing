
import 'package:flutter/material.dart';

class EvalBar extends StatelessWidget {
  final int? evalCentipawns;
  final bool isFlipped; // true if Black orientation is at the bottom

  const EvalBar({
    super.key,
    required this.evalCentipawns,
    this.isFlipped = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int rawEval = evalCentipawns ?? 0;

    // A value of +10000 or -10000 indicates checkmate
    final bool isMate = rawEval.abs() > 5000;
    
    // Label calculation
    String label = '0.0';
    if (isMate) {
      label = rawEval > 0 ? 'M' : '-M';
    } else {
      final double pawns = rawEval / 100.0;
      if (pawns > 0) {
        label = '+${pawns.toStringAsFixed(1)}';
      } else if (pawns < 0) {
        label = pawns.toStringAsFixed(1);
      } else {
        label = '0.0';
      }
    }

    // Map centipawns to 0.0 -> 1.0 proportion for White
    // Clip between -800 cp and +800 cp
    final double clippedEval = rawEval.clamp(-800, 800).toDouble();
    double whiteProportion = (clippedEval + 800) / 1600.0;

    // If flipped, Black is at the bottom. The bar represents White's proportion from top or bottom.
    // Standard (White at bottom): White is at the bottom, Black is at the top.
    // Flipped (Black at bottom): Black is at the bottom, White is at the top.
    double fillProportion = isFlipped ? (1.0 - whiteProportion) : whiteProportion;

    return Container(
      width: 28,
      decoration: BoxDecoration(
        color: Colors.black, // Black advantage (top/bottom color)
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Stack(
        alignment: isFlipped ? Alignment.topCenter : Alignment.bottomCenter,
        children: [
          // White fill
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: double.infinity,
            alignment: isFlipped ? Alignment.topCenter : Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: fillProportion,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4.5),
                ),
              ),
            ),
          ),
          
          // Eval value text overlay
          Positioned(
            left: 0,
            right: 0,
            // Draw text near the middle or appropriate side
            top: isFlipped ? 8 : null,
            bottom: isFlipped ? null : 8,
            child: RotatedBox(
              quarterTurns: 1,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    // If White's proportion is high, use dark text on white background, else white text on black background
                    color: (fillProportion > 0.5) ^ isFlipped ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
