import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squares/squares.dart' as sq;
import '../../../../core/ai/coaching_service.dart';

class BestMoveCard extends ConsumerWidget {
  final String? bestMoveUci;
  final String? playerMoveUci;
  final String fen;
  final VoidCallback onToggleArrow;
  final bool showArrow;

  const BestMoveCard({
    super.key,
    required this.bestMoveUci,
    required this.playerMoveUci,
    required this.fen,
    required this.onToggleArrow,
    required this.showArrow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (bestMoveUci == null || bestMoveUci!.isEmpty) {
      return const SizedBox.shrink();
    }

    final fromName = bestMoveUci!.substring(0, 2);
    final toName = bestMoveUci!.substring(2, 4);

    final tipAsyncValue = ref.watch(
      bestMoveTipProvider(
        BestMoveTipArg(
          fen: fen,
          bestMoveUci: bestMoveUci!,
          playerMoveUci: playerMoveUci ?? '',
        ),
      ),
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Best Move Recommendation',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onToggleArrow,
                  icon: Icon(showArrow ? Icons.visibility : Icons.visibility_off, size: 16),
                  label: Text(showArrow ? 'Hide Hint' : 'Show Hint', style: const TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Stockfish suggests playing $fromName → $toName instead of your move.',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            tipAsyncValue.when(
              data: (tip) => Text(
                'Coaching Tip: $tip',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              loading: () => Row(
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Asking Gemini coach...',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                ],
              ),
              error: (error, _) => Text(
                'Coaching Tip: Could not get advice from Gemini.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BestMoveArrowOverlay extends StatelessWidget {
  final String uci;
  final int orientation; // 0 for White at bottom, 1 for Black at bottom

  const BestMoveArrowOverlay({
    super.key,
    required this.uci,
    required this.orientation,
  });

  @override
  Widget build(BuildContext context) {
    if (uci.length < 4) return const SizedBox.shrink();

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double boardSize = constraints.maxWidth;
          final double cellWidth = boardSize / 8;
          final double cellHeight = boardSize / 8;

          final sqSize = sq.BoardSize.standard;
          final fromIndex = sqSize.squareNumber(uci.substring(0, 2));
          final toIndex = sqSize.squareNumber(uci.substring(2, 4));

          Offset getCenter(int index) {
            final int file = index % 8;
            final int rank = index ~/ 8;

            double x, y;
            if (orientation == 0) {
              x = file * cellWidth + cellWidth / 2;
              y = rank * cellHeight + cellHeight / 2;
            } else {
              x = (7 - file) * cellWidth + cellWidth / 2;
              y = (7 - rank) * cellHeight + cellHeight / 2;
            }
            return Offset(x, y);
          }

          final fromOffset = getCenter(fromIndex);
          final toOffset = getCenter(toIndex);

          return CustomPaint(
            size: Size(boardSize, boardSize),
            painter: ArrowPainter(
              from: fromOffset,
              to: toOffset,
              color: Colors.green.withValues(alpha: 0.75),
            ),
          );
        },
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final Color color;

  ArrowPainter({
    required this.from,
    required this.to,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double distance = sqrt(pow(to.dx - from.dx, 2) + pow(to.dy - from.dy, 2));
    
    // Shorten line slightly so arrow sits nicely
    Offset finalTo = to;
    if (distance > 30) {
      final double shortenBy = 15.0;
      final double ratio = (distance - shortenBy) / distance;
      finalTo = Offset(
        from.dx + (to.dx - from.dx) * ratio,
        from.dy + (to.dy - from.dy) * ratio,
      );
    }

    // Draw the shaft of the arrow
    canvas.drawLine(from, finalTo, paint);

    // Draw arrowhead at finalTo
    final double angle = atan2(to.dy - from.dy, to.dx - from.dx);
    final double arrowSize = 16.0;

    final path = Path()
      ..moveTo(finalTo.dx, finalTo.dy)
      ..lineTo(
        finalTo.dx - arrowSize * cos(angle - pi / 6),
        finalTo.dy - arrowSize * sin(angle - pi / 6),
      )
      ..lineTo(
        finalTo.dx - arrowSize * cos(angle + pi / 6),
        finalTo.dy - arrowSize * sin(angle + pi / 6),
      )
      ..close();

    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! ArrowPainter ||
        oldDelegate.from != from ||
        oldDelegate.to != to ||
        oldDelegate.color != color;
  }
}
