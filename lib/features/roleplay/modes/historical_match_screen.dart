import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:squares/squares.dart' as sq;
import 'package:square_bishop/square_bishop.dart';
import '../../../core/database/app_database.dart';
import '../../../core/supabase/repositories/historical_matches_repository.dart';
import '../../../shared/widgets/board_theme_builder.dart';
import '../models/historical_match_model.dart';
import 'historical_match_provider.dart';

part 'historical_match_screen.g.dart';

@riverpod
Future<List<HistoricalMatchModel>> historicalMatches(Ref ref) async {
  final repo = HistoricalMatchesRepository(
    ref.read(historicalMatchesDaoProvider),
    ref.read(cacheServiceProvider),
  );
  // Serves cache first, background refresh if stale
  return await repo.get();
}

class HistoricalMatchScreen extends ConsumerWidget {
  const HistoricalMatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final matchesAsync = ref.watch(historicalMatchesProvider);
    final matchState = ref.watch(historicalMatchStateProvider);
    final notifier = ref.read(historicalMatchStateProvider.notifier);

    return matchesAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Historical Match')),
        body: Center(child: Text('Error loading historical matches: $err')),
      ),
      data: (matches) {
        if (matches.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Historical Match')),
            body: const Center(child: Text('No historical matches available.')),
          );
        }

        // Initialize selection to the first match if unselected
        if (matchState.selectedGameId == null) {
          final firstGame = matches.first;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifier.selectGame(firstGame);
          });
        }

        final selectedGame = matches.firstWhere(
          (m) => m.id == matchState.selectedGameId,
          orElse: () => matches.first,
        );

        final squaresState = matchState.game.squaresState(0); // White orientation

        return Scaffold(
          appBar: AppBar(
            title: const Text('Historical Match Commentary'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dropdown
                  Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Select Historical Match',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<HistoricalMatchModel>(
                            isExpanded: true,
                            initialValue: selectedGame,
                            items: matches.map((g) {
                              return DropdownMenuItem<HistoricalMatchModel>(
                                value: g,
                                child: Text("${g.whitePlayer} vs. ${g.blackPlayer} (${g.year})"),
                              );
                            }).toList(),
                            onChanged: (g) {
                              if (g != null) {
                                notifier.selectGame(g);
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Chessboard
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
              const SizedBox(height: 12),

              // Ply navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.first_page),
                    onPressed: matchState.currentPly > -1 ? () => notifier.loadPly(-1) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: matchState.currentPly > -1 ? () => notifier.loadPly(matchState.currentPly - 1) : null,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      matchState.currentPly == -1
                          ? 'Starting Position'
                          : 'Move ${(matchState.currentPly + 2) ~/ 2} / ${(matchState.moves.length + 1) ~/ 2}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: matchState.currentPly < matchState.moves.length - 1 ? () => notifier.loadPly(matchState.currentPly + 1) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.last_page),
                    onPressed: matchState.currentPly < matchState.moves.length - 1 ? () => notifier.loadPly(matchState.moves.length - 1) : null,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Get Commentary Button
              ElevatedButton.icon(
                onPressed: matchState.currentPly >= 0 && !matchState.isLoadingCommentary ? () => notifier.fetchCommentary(selectedGame) : null,
                icon: const Icon(Icons.comment, color: Colors.white),
                label: const Text('GET LIVE COMMENTARY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),

              // Commentary Box
              if (matchState.isLoadingCommentary)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (matchState.commentary != null)
                Card(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.mic, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Live Commentator',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          matchState.commentary!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                            fontWeight: FontWeight.w500,
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
      },
    );
  }
}
