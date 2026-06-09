import 'dart:ui';
import 'package:flutter/material.dart';
import '../board_state.dart';

class GameOverOverlay extends StatelessWidget {
  final BoardState state;
  final VoidCallback onPlayAgain;
  final VoidCallback onChangeSettings;

  const GameOverOverlay({
    super.key,
    required this.state,
    required this.onPlayAgain,
    required this.onChangeSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    String resultTitle = '';
    bool isVictory = false;
    bool isDraw = false;
    bool isResigned = false;

    switch (state.status) {
      case GameStatus.checkmate:
        final playerWon = !state.isPlayerTurn;
        resultTitle = playerWon ? 'You Won' : 'You Lost';
        isVictory = playerWon;
        break;
      case GameStatus.resigned:
        resultTitle = 'You Resigned';
        isResigned = true;
        break;
      case GameStatus.stalemate:
      case GameStatus.draw:
        resultTitle = 'Draw';
        isDraw = true;
        break;
      case GameStatus.timeout:
        final isPlayerWhite = state.playerColorIndex == 0;
        final playerRanOutOfTime = isPlayerWhite
            ? state.whiteTime == Duration.zero
            : state.blackTime == Duration.zero;
        final playerWon = !playerRanOutOfTime;
        resultTitle = playerWon ? 'You Won' : 'You Lost';
        isVictory = playerWon;
        break;
      default:
        resultTitle = 'Game Over';
    }

    IconData outcomeIcon;
    Color iconColor;
    if (isVictory) {
      outcomeIcon = Icons.emoji_events_rounded;
      iconColor = Colors.amber;
    } else if (isDraw) {
      outcomeIcon = Icons.balance_rounded;
      iconColor = Colors.grey;
    } else if (isResigned) {
      outcomeIcon = Icons.flag_rounded;
      iconColor = Colors.redAccent;
    } else {
      outcomeIcon = Icons.sentiment_dissatisfied_rounded;
      iconColor = Colors.redAccent;
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
                    // Outcome Icon
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          outcomeIcon,
                          size: 64,
                          color: iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Outcome Text
                    Text(
                      resultTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Play Again button
                    ElevatedButton.icon(
                      onPressed: onPlayAgain,
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      label: const Text(
                        'New Game',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Return to Play Menu button
                    OutlinedButton.icon(
                      onPressed: onChangeSettings,
                      icon: Icon(Icons.exit_to_app_rounded, color: cs.primary),
                      label: Text(
                        'Return to Play Menu',
                        style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary, letterSpacing: 0.5),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: cs.primary, width: 1.5),
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
