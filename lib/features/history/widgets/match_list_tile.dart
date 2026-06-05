import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game_summary.dart';

class MatchListTile extends StatelessWidget {
  final GameSummary game;
  final VoidCallback onTap;

  const MatchListTile({super.key, required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final playerWon = game.result == '1-0' && game.playerColorIndex == 0 ||
        game.result == '0-1' && game.playerColorIndex == 1;
    final isDraw = game.result == '1/2-1/2';
    final playerLost = !playerWon && !isDraw;

    final resultLabel = playerWon ? 'W' : (isDraw ? 'D' : 'L');
    final resultColor = playerWon
        ? const Color(0xFF4CAF50)
        : isDraw
            ? const Color(0xFF9E9E9E)
            : const Color(0xFFF44336);

    final dateStr =
        DateFormat('MMM d, yyyy · HH:mm').format(game.playedAt.toLocal());

    final modeLabel = _modeLabel(game);
    final accuracy = game.playerAccuracy;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: resultColor.withValues(alpha: playerLost ? 0.15 : 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Result chip
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: resultColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  resultLabel,
                  style: TextStyle(
                    color: resultColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Main info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modeLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dateStr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // Right: accuracy + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (accuracy != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _accuracyColor(accuracy).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$accuracy%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _accuracyColor(accuracy),
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: cs.onSurface.withValues(alpha: 0.3),
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _modeLabel(GameSummary game) {
    switch (game.mode) {
      case 'timed':
        final secs = game.timeControlSeconds ?? 0;
        final mins = secs ~/ 60;
        return 'Timed · ${mins}min';
      case 'level':
        return 'Level ${game.botLevel ?? '?'} Bot';
      case 'free':
        return 'Free Play';
      default:
        return game.mode;
    }
  }

  Color _accuracyColor(int acc) {
    if (acc >= 85) return const Color(0xFF4CAF50);
    if (acc >= 65) return const Color(0xFFFFC107);
    return const Color(0xFFF44336);
  }
}
