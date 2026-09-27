import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squares/squares.dart' as sq;
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/chess_move_utils.dart';
import '../../../shared/widgets/board_theme_builder.dart';
import 'why_this_move_provider.dart';

class WhyThisMoveScreen extends ConsumerStatefulWidget {
  const WhyThisMoveScreen({super.key});

  @override
  ConsumerState<WhyThisMoveScreen> createState() => _WhyThisMoveScreenState();
}

class _WhyThisMoveScreenState extends ConsumerState<WhyThisMoveScreen> {
  late final TextEditingController _fenController;

  @override
  void initState() {
    super.initState();
    _fenController = TextEditingController(text: ref.read(whyThisMoveProvider).fen);
  }

  @override
  void dispose() {
    _fenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen<WhyThisMoveState>(whyThisMoveProvider, (previous, next) {
      if (previous?.fen != next.fen) {
        _fenController.text = next.fen;
      }
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        ref.read(whyThisMoveProvider.notifier).clearError();
      }
    });

    final state = ref.watch(whyThisMoveProvider);
    final notifier = ref.read(whyThisMoveProvider.notifier);
    final squaresState = state.game.squaresState(0); // White at bottom
    final legalMoves = state.game.generateLegalMoves();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roleplay: Why This Move?'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Position Loader Options
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Step 1: Set Board Position',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // FEN input
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _fenController,
                              decoration: const InputDecoration(
                                labelText: 'FEN String',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => notifier.updateFen(_fenController.text),
                            child: const Text('Load'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Recent games loader
                      if (state.recentGames.isNotEmpty) ...[
                        DropdownButtonFormField<Game>(
                          decoration: const InputDecoration(
                            labelText: 'Load position from recent games',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          initialValue: state.selectedRecentGame,
                          items: state.recentGames.map((g) {
                            final dateStr = "${g.playedAt.day}/${g.playedAt.month}";
                            return DropdownMenuItem<Game>(
                              value: g,
                              child: Text('${g.mode.toUpperCase()} game - result: ${g.result} ($dateStr)'),
                            );
                          }).toList(),
                          onChanged: notifier.onGameSelected,
                        ),
                        if (state.selectedRecentGame != null && state.selectedGameMoves.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: state.selectedMovePly > 0
                                    ? () => notifier.loadPlyPosition(state.selectedMovePly - 1)
                                    : null,
                              ),
                              Expanded(
                                child: Text(
                                  'Move ${state.selectedMovePly + 1} / ${state.selectedGameMoves.length}: ${state.selectedGameMoves[state.selectedMovePly].san}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: state.selectedMovePly < state.selectedGameMoves.length - 1
                                    ? () => notifier.loadPlyPosition(state.selectedMovePly + 1)
                                    : null,
                              ),
                            ],
                          ),
                        ]
                      ],
                    ],
                  ),
                ),
              ),

              // Chessboard Display
              Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: sq.Board(
                        state: squaresState.board,
                        pieceSet: sq.PieceSet.merida(),
                        theme: BoardThemeBuilder.build(context, ref),
                        size: squaresState.size,
                        draggable: false,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Step 2: Select Move
              Text(
                'Step 2: Choose a Move to Explain',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (legalMoves.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('No legal moves in this position.', style: TextStyle(fontStyle: FontStyle.italic)),
                )
              else
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: legalMoves.length,
                    itemBuilder: (context, index) {
                      final m = legalMoves[index];
                      final san = state.game.toSan(m);
                      final uci = ChessMoveUtils.toUci(state.game, m);
                      final isSelected = state.selectedMoveUci == uci;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(san),
                          selected: isSelected,
                          selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                          onSelected: (_) => notifier.selectMove(m),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 16),

              // Explain Button
              ElevatedButton.icon(
                onPressed: state.selectedMoveUci != null && !state.isLoading
                    ? notifier.askMagnus
                    : null,
                icon: const Icon(Icons.psychology, color: Colors.white),
                label: const Text('ASK MAGNUS CARLSEN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              const SizedBox(height: 16),

              // Explanation Chat Bubble
              if (state.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state.explanation != null)
                Card(
                  color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: theme.colorScheme.primary,
                              radius: 16,
                              child: const Text('MC', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Magnus Carlsen',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.explanation!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
