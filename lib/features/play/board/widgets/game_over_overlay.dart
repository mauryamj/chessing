import 'dart:ui';
import 'package:flutter/material.dart';
import '../board_state.dart';

class GameOverOverlay extends StatelessWidget {
  final BoardState state;
  final VoidCallback onPlayAgain;
  final VoidCallback onChangeSettings;
  final VoidCallback onReview;

  const GameOverOverlay({
    super.key,
    required this.state,
    required this.onPlayAgain,
    required this.onChangeSettings,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDefeat = state.wasDefeat;

    String resultTitle = '';
    switch (state.status) {
      case GameStatus.checkmate:
        resultTitle = isDefeat ? 'Checkmate · Defeat' : 'Checkmate · Victory!';
        break;
      case GameStatus.resigned:
        resultTitle = isDefeat ? 'Resigned · Defeat' : 'Opponent Resigned · Victory!';
        break;
      case GameStatus.stalemate:
        resultTitle = 'Draw by Stalemate';
        break;
      case GameStatus.draw:
        resultTitle = 'Match Drawn';
        break;
      case GameStatus.timeout:
        resultTitle = isDefeat ? 'Timeout · Defeat' : 'Timeout · Victory!';
        break;
      default:
        resultTitle = 'Game Over';
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: Colors.black.withValues(alpha: 0.65),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: Card(
              color: theme.cardTheme.color?.withValues(alpha: 0.95) ?? theme.colorScheme.surface.withValues(alpha: 0.95),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Outcome Icon with animation / premium style
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (isDefeat ? Colors.red : Colors.amber).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isDefeat ? Icons.sentiment_dissatisfied : Icons.emoji_events_rounded,
                          size: 64,
                          color: isDefeat ? Colors.redAccent : Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Outcome Text
                    Text(
                      resultTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Additional subtitle info
                    Text(
                      'The match has concluded. Review the analysis to see mistakes and learn key ideas.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Play Again button
                    ElevatedButton.icon(
                      onPressed: onPlayAgain,
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      label: const Text(
                        'PLAY AGAIN',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDefeat ? Colors.redAccent : Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Review Game button
                    OutlinedButton.icon(
                      onPressed: onReview,
                      icon: Icon(Icons.analytics_rounded, color: cs.primary),
                      label: Text(
                        'REVIEW ANALYSIS',
                        style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary, letterSpacing: 0.5),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: cs.primary, width: 1.5),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Back to Menu button
                    TextButton.icon(
                      onPressed: onChangeSettings,
                      icon: Icon(Icons.tune_rounded, color: theme.hintColor),
                      label: Text(
                        'Change Level / Mode',
                        style: TextStyle(color: theme.hintColor, fontWeight: FontWeight.w600),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
