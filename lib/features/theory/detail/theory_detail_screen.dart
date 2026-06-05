import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squares/squares.dart' as sq;
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';
import '../library/theory_provider.dart';
import '../models/theory_entry.dart';
import '../../../core/ai/coaching_service.dart';
import '../../../core/ai/prompts.dart';
import '../../../app/theme.dart';

class TheoryDetailScreen extends ConsumerStatefulWidget {
  final String theoryId;
  const TheoryDetailScreen({super.key, required this.theoryId});

  @override
  ConsumerState<TheoryDetailScreen> createState() => _TheoryDetailScreenState();
}

class _TheoryDetailScreenState extends ConsumerState<TheoryDetailScreen> {
  bishop.Game _game = bishop.Game(variant: bishop.Variant.standard());
  int _currentPly = -1; // -1 is start position
  List<String> _currentLineMoves = [];
  String? _selectedVariationName;

  // AI explanation cache for current FEN
  String? _aiExplanation;
  bool _isLoadingExplanation = false;

  @override
  void initState() {
    super.initState();
  }

  void _initMainLine(TheoryEntry entry) {
    if (_currentLineMoves.isEmpty) {
      _currentLineMoves = List.from(entry.moves);
      _game = bishop.Game(variant: bishop.Variant.standard());
    }
  }

  void _loadPly(int ply) {
    if (ply < -1 || ply >= _currentLineMoves.length) return;
    
    final bp = bishop.Game(variant: bishop.Variant.standard());
    for (int i = 0; i <= ply; i++) {
      final sqMove = bp.squaresSize.moveFromAlgebraic(_currentLineMoves[i]);
      bp.makeSquaresMove(sqMove);
    }
    setState(() {
      _currentPly = ply;
      _game = bp;
      _aiExplanation = null; // Clear explanation when moving
    });
  }

  void _loadVariation(TheoryVariation variation) {
    // Variations branch from the current position, or we can just append them/reset.
    // In chess theory, a variation usually branches off a specific ply or the starting FEN.
    // Let's assume variations in our simple JSON branch from the STARTING position of the opening.
    // (In sicilian-najdorf, the variation moves are appended to the main line base).
    // Let's reset the line moves to the main Najdorf line + variation moves.
    final baseEntry = ref.read(theoryEntryByIdProvider(widget.theoryId)).value;
    if (baseEntry == null) return;

    setState(() {
      _selectedVariationName = variation.name;
      _currentLineMoves = [...baseEntry.moves, ...variation.moves];
      _loadPly(baseEntry.moves.length - 1); // Start where variation begins
    });
  }

  void _resetToMainLine(TheoryEntry entry) {
    setState(() {
      _selectedVariationName = null;
      _currentLineMoves = List.from(entry.moves);
      _loadPly(-1);
    });
  }

  Future<void> _fetchAiCoachAdvice() async {
    setState(() {
      _isLoadingExplanation = true;
      _aiExplanation = null;
    });

    try {
      final coach = ref.read(coachingServiceProvider);
      // Let's ask Gemini to explain the current FEN position
      final response = await coach.ask(
        AiPrompts.theoryExplanationSystem,
        "Position FEN: ${_game.fen}"
      );
      setState(() {
        _aiExplanation = response;
      });
    } catch (e) {
      setState(() {
        _aiExplanation = "Unable to load coaching commentary. Check connection.";
      });
    } finally {
      setState(() {
        _isLoadingExplanation = false;
      });
    }
  }

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
  Widget build(BuildContext context) {
    final entryAsyncValue = ref.watch(theoryEntryByIdProvider(widget.theoryId));
    final theoryStateAsync = ref.watch(theoryNotifierProvider);
    final isBookmarked = theoryStateAsync.value?.isBookmarked(widget.theoryId) ?? false;
    final isCompleted = theoryStateAsync.value?.isCompleted(widget.theoryId) ?? false;
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
              ref.read(theoryNotifierProvider.notifier).toggleBookmark(widget.theoryId);
            },
          ),
        ],
      ),
      body: entryAsyncValue.when(
        data: (entry) {
          if (entry == null) {
            return const Center(child: Text('Theory entry not found.'));
          }

          _initMainLine(entry);
          final squaresState = _game.squaresState(0); // White orientation

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
                            theme: _getBoardTheme(context),
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
                        onPressed: _currentPly > -1 ? () => _loadPly(-1) : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _currentPly > -1 ? () => _loadPly(_currentPly - 1) : null,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _currentPly == -1
                              ? 'Start Position'
                              : 'Move ${(_currentPly + 2) ~/ 2} / ${(_currentLineMoves.length + 1) ~/ 2}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _currentPly < _currentLineMoves.length - 1
                            ? () => _loadPly(_currentPly + 1)
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.last_page),
                        onPressed: _currentPly < _currentLineMoves.length - 1
                            ? () => _loadPly(_currentLineMoves.length - 1)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ask Gemini Coach for position commentary
                  ElevatedButton.icon(
                    onPressed: !_isLoadingExplanation ? _fetchAiCoachAdvice : null,
                    icon: const Icon(Icons.psychology, color: Colors.white),
                    label: const Text('ASK COACH ABOUT THIS POSITION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_isLoadingExplanation)
                    const Center(child: CircularProgressIndicator())
                  else if (_aiExplanation != null)
                    Card(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Coach: $_aiExplanation',
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
                        if (_selectedVariationName != null)
                          TextButton(
                            onPressed: () => _resetToMainLine(entry),
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
                        final isSelected = _selectedVariationName == v.name;

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
                            onTap: () => _loadVariation(v),
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
                        ref.read(theoryNotifierProvider.notifier).markCompleted(widget.theoryId);
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
