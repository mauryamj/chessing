import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squares/squares.dart' as sq;
import 'package:square_bishop/square_bishop.dart';
import '../library/theory_provider.dart';
import '../../../shared/widgets/board_theme_builder.dart';
import 'theory_detail_provider.dart';

class TheoryDetailScreen extends ConsumerWidget {
  final String theoryId;
  const TheoryDetailScreen({super.key, required this.theoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryAsyncValue = ref.watch(theoryEntryByIdProvider(theoryId));
    final theoryStateAsync = ref.watch(theoryNotifierProvider);
    final detailState = ref.watch(theoryDetailProvider(theoryId));
    final notifier = ref.read(theoryDetailProvider(theoryId).notifier);

    final isBookmarked = theoryStateAsync.value?.isBookmarked(theoryId) ?? false;
    final isCompleted = theoryStateAsync.value?.isCompleted(theoryId) ?? false;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lesson Detail',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.amber : null,
            ),
            onPressed: () {
              ref.read(theoryNotifierProvider.notifier).toggleBookmark(theoryId);
            },
          ),
        ],
      ),
      body: entryAsyncValue.when(
        data: (entry) {
          if (entry == null) {
            return const Center(child: Text('Theory entry not found.'));
          }

          if (detailState.currentLineMoves.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              notifier.initMainLine(entry);
            });
          }

          final squaresState = detailState.game.squaresState(0); // White orientation

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Lesson Title & Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.summary,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

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

                  // Navigation Step Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.first_page),
                        onPressed: detailState.currentPly > -1 ? () => notifier.loadPly(-1) : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: detailState.currentPly > -1 ? () => notifier.loadPly(detailState.currentPly - 1) : null,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          detailState.currentPly == -1
                              ? 'Start Position'
                              : 'Move ${(detailState.currentPly + 2) ~/ 2} / ${(detailState.currentLineMoves.length + 1) ~/ 2}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: detailState.currentPly < detailState.currentLineMoves.length - 1
                            ? () => notifier.loadPly(detailState.currentPly + 1)
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.last_page),
                        onPressed: detailState.currentPly < detailState.currentLineMoves.length - 1
                            ? () => notifier.loadPly(detailState.currentLineMoves.length - 1)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ask Gemini Coach for position commentary
                  ElevatedButton.icon(
                    onPressed: !detailState.isLoadingExplanation ? notifier.fetchAiCoachAdvice : null,
                    icon: const Icon(Icons.psychology, color: Colors.white),
                    label: const Text('ASK COACH ABOUT THIS POSITION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (detailState.isLoadingExplanation)
                    const Center(child: CircularProgressIndicator())
                  else if (detailState.aiExplanation != null)
                    Card(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Coach: ${detailState.aiExplanation}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Key Ideas
                  Text(
                    'Key Strategic Ideas',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.keyIdeas.map((idea) {
                      return Chip(
                        avatar: Icon(Icons.check_circle_outline, size: 16, color: theme.colorScheme.primary),
                        label: Text(idea),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Variations Tree
                  if (entry.variations.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Variations & Branches',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (detailState.selectedVariationName != null)
                          TextButton(
                            onPressed: () => notifier.resetToMainLine(entry),
                            child: const Text('Reset to Main Line'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entry.variations.length,
                      itemBuilder: (context, index) {
                        final v = entry.variations[index];
                        final isSelected = detailState.selectedVariationName == v.name;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              v.name,
                              style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                            ),
                            subtitle: Text('Moves: ${v.moves.join(", ")}'),
                            trailing: isSelected
                                ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                                : const Icon(Icons.arrow_forward),
                            onTap: () => notifier.loadVariation(entry, v),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'LESSON COMPLETED',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(theoryNotifierProvider.notifier).markCompleted(theoryId);
                      },
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: const Text('MARK LESSON AS COMPLETED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) => Scaffold(body: Center(child: Text('Error loading lesson: $err'))),
      ),
    );
  }
}
