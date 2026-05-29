import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:squares/squares.dart' as sq;
import 'review_provider.dart';
import 'widgets/eval_bar.dart';
import 'widgets/move_timeline.dart';
import 'widgets/blunder_map.dart';
import 'widgets/best_move_card.dart';
import '../../../app/theme.dart';

class ReviewScreen extends ConsumerWidget {
  final int gameId;

  const ReviewScreen({super.key, required this.gameId});

  sq.BoardTheme _getBoardTheme(BuildContext context) {
    final ext = Theme.of(context).extension<ChessBoardTheme>();
    if (ext == null) return sq.BoardTheme.brown;
    return sq.BoardTheme(
      lightSquare: ext.lightSquareColor,
      darkSquare: ext.darkSquareColor,
      check: ext.checkSquareColor,
      checkmate: Colors.orange,
      previous: ext.lastMoveDestColor,
      selected: ext.selectedSquareColor,
      premove: const Color(0x807B56B3),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewState = ref.watch(reviewStateProvider(gameId));
    final notifier = ref.read(reviewStateProvider(gameId).notifier);
    final theme = Theme.of(context);

    if (reviewState.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Match')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: theme.colorScheme.error, size: 64),
              const SizedBox(height: 16),
              Text(
                reviewState.error!,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (reviewState.game.pgn.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Loading match details...', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    final int currentPly = reviewState.currentPly;
    
    // Check if there is an active best move suggested for the current position
    final String? currentBestMove = currentPly >= 0 ? reviewState.moves[currentPly].bestMoveUci : null;
    final String? currentPlayerMove = currentPly >= 0 ? reviewState.moves[currentPly].uci : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Match Review',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (reviewState.game.playerAccuracy != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Accuracy: ${reviewState.game.playerAccuracy}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: reviewState.isAnalyzing
            ? _buildAnalysisProgressOverlay(reviewState, theme)
            : Column(
                children: [
                  // Board & Eval Bar Row
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left Side Vertical Eval Bar
                          EvalBar(
                            evalCentipawns: currentPly >= 0 ? reviewState.moves[currentPly].eval : 0,
                            isFlipped: reviewState.game.playerColorIndex == 1,
                          ),
                          const SizedBox(width: 12),
                          // Board
                          Expanded(
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.12),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      children: [
                                        sq.Board(
                                          state: reviewState.currentSquaresState.board,
                                          pieceSet: sq.PieceSet.merida(),
                                          theme: _getBoardTheme(context),
                                          size: reviewState.currentSquaresState.size,
                                          draggable: false,
                                          overlays: [
                                            if (reviewState.showBestMoveArrow &&
                                                currentBestMove != null &&
                                                currentBestMove.isNotEmpty &&
                                                currentPlayerMove != currentBestMove)
                                              BestMoveArrowOverlay(
                                                uci: currentBestMove,
                                                orientation: reviewState.game.playerColorIndex,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Navigation Step Controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.first_page),
                          onPressed: () => notifier.goToPly(-1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: currentPly > -1 ? notifier.stepBackward : null,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            currentPly == -1
                                ? 'Start Position'
                                : 'Move ${((currentPly + 2) ~/ 2)} / ${((reviewState.moves.length + 1) ~/ 2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: currentPly < reviewState.moves.length - 1 ? notifier.stepForward : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.last_page),
                          onPressed: () => notifier.goToPly(reviewState.moves.length - 1),
                        ),
                      ],
                    ),
                  ),

                  // Move Timeline Evaluation Swings
                  MoveTimeline(
                    moves: reviewState.moves,
                    currentPly: currentPly,
                    onPlySelected: notifier.goToPly,
                  ),

                  // Bottom scrollable analysis reports
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Best Move Card overlay toggle
                            if (currentBestMove != null && currentPlayerMove != currentBestMove)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: BestMoveCard(
                                  bestMoveUci: currentBestMove,
                                  playerMoveUci: currentPlayerMove,
                                  fen: reviewState.moves[currentPly].fen,
                                  showArrow: reviewState.showBestMoveArrow,
                                  onToggleArrow: notifier.toggleBestMoveArrow,
                                ),
                              ),

                            // Blunder & Mistake Stats
                            BlunderMap(
                              moves: reviewState.moves,
                              onPlySelected: notifier.goToPly,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Move list wrapped chips
                            Text(
                              'Moves list:',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: List.generate(reviewState.moves.length, (index) {
                                final m = reviewState.moves[index];
                                final isActive = index == currentPly;
                                
                                Color chipBg = theme.colorScheme.surface;
                                Color textColor = theme.colorScheme.onSurface;
                                
                                if (m.classification == 'best') {
                                  chipBg = Colors.green.withValues(alpha: isActive ? 0.25 : 0.08);
                                  textColor = Colors.green;
                                } else if (m.classification == 'good') {
                                  chipBg = Colors.teal.withValues(alpha: isActive ? 0.25 : 0.08);
                                  textColor = Colors.teal;
                                } else if (m.classification == 'inaccuracy') {
                                  chipBg = Colors.yellow[700]!.withValues(alpha: isActive ? 0.35 : 0.1);
                                  textColor = Colors.yellow[900]!;
                                } else if (m.classification == 'mistake') {
                                  chipBg = Colors.orange.withValues(alpha: isActive ? 0.25 : 0.08);
                                  textColor = Colors.orange;
                                } else if (m.classification == 'blunder') {
                                  chipBg = Colors.red.withValues(alpha: isActive ? 0.25 : 0.08);
                                  textColor = Colors.red;
                                }
                                
                                final moveNum = (index ~/ 2) + 1;
                                final isWhite = index % 2 == 0;
                                final label = isWhite ? '$moveNum. ${m.san}' : m.san;

                                return ChoiceChip(
                                  label: Text(
                                    label,
                                    style: TextStyle(
                                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                      color: textColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  selected: isActive,
                                  selectedColor: chipBg,
                                  backgroundColor: chipBg.withValues(alpha: 0.02),
                                  onSelected: (_) => notifier.goToPly(index),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: isActive ? textColor : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAnalysisProgressOverlay(ReviewState reviewState, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.query_stats, color: theme.colorScheme.primary, size: 72),
            const SizedBox(height: 24),
            Text(
              'Running Stockfish Game Analysis...',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Evaluating move classifications, blunder detection, and positional accuracy.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: reviewState.analysisProgress,
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Analyzing Position: ${reviewState.analyzedPlies} / ${reviewState.totalPlies} (${(reviewState.analysisProgress * 100).toInt()}%)',
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
