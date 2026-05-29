import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squares/squares.dart' as sq;
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';
import '../../../core/ai/coaching_service.dart';
import '../../../core/database/app_database.dart';
import '../../../app/theme.dart';

class WhyThisMoveScreen extends ConsumerStatefulWidget {
  const WhyThisMoveScreen({super.key});

  @override
  ConsumerState<WhyThisMoveScreen> createState() => _WhyThisMoveScreenState();
}

class _WhyThisMoveScreenState extends ConsumerState<WhyThisMoveScreen> {
  late bishop.Game _game;
  String _fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  final TextEditingController _fenController = TextEditingController();
  
  List<Game> _recentGames = [];
  Game? _selectedRecentGame;
  List<Move> _selectedGameMoves = [];
  int _selectedMovePly = 0;

  String? _selectedMoveUci;
  String? _explanation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _game = bishop.Game(variant: bishop.Variant.standard(), fen: _fen);
    _fenController.text = _fen;
    _loadRecentGames();
  }

  Future<void> _loadRecentGames() async {
    final db = ref.read(databaseProvider);
    final games = await db.getRecentGames(5);
    setState(() {
      _recentGames = games;
    });
  }

  Future<void> _onGameSelected(Game? game) async {
    if (game == null) return;
    final db = ref.read(databaseProvider);
    final moves = await db.getMovesForGame(game.id);
    
    // Sort moves by ply
    final sortedMoves = [...moves]..sort((a, b) => a.ply.compareTo(b.ply));

    setState(() {
      _selectedRecentGame = game;
      _selectedGameMoves = sortedMoves;
      _selectedMovePly = 0;
      if (sortedMoves.isNotEmpty) {
        _loadPlyPosition(0);
      }
    });
  }

  void _loadPlyPosition(int plyIndex) {
    if (_selectedGameMoves.isEmpty || plyIndex < 0 || plyIndex >= _selectedGameMoves.length) return;
    
    // Play moves up to this ply
    final bp = bishop.Game(variant: bishop.Variant.standard());
    for (int i = 0; i < plyIndex; i++) {
      final sqMove = bp.squaresSize.moveFromAlgebraic(_selectedGameMoves[i].uci);
      bp.makeSquaresMove(sqMove);
    }
    
    final currentUci = _selectedGameMoves[plyIndex].uci;
    
    setState(() {
      _fen = bp.fen;
      _fenController.text = bp.fen;
      _game = bp;
      _selectedMoveUci = currentUci;
      _selectedMovePly = plyIndex;
      _explanation = null;
    });
  }

  void _updateFen(String newFen) {
    try {
      final bp = bishop.Game(variant: bishop.Variant.standard(), fen: newFen);
      setState(() {
        _fen = newFen;
        _game = bp;
        _selectedMoveUci = null;
        _explanation = null;
        _selectedRecentGame = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid FEN position: $e')),
      );
    }
  }

  void _onMoveSelected(bishop.Move m) {
    final fromStr = _game.size.squareName(m.from);
    final toStr = _game.size.squareName(m.to);
    String promoStr = '';
    if (m.promotion && m.promoPiece != null) {
      switch (m.promoPiece) {
        case 2: promoStr = 'n'; break;
        case 3: promoStr = 'b'; break;
        case 4: promoStr = 'r'; break;
        case 5: promoStr = 'q'; break;
      }
    }
    final uci = '$fromStr$toStr$promoStr';
    setState(() {
      _selectedMoveUci = uci;
      _explanation = null;
    });
  }

  Future<void> _askMagnus() async {
    if (_selectedMoveUci == null) return;
    setState(() {
      _isLoading = true;
      _explanation = null;
    });

    try {
      final coach = ref.read(coachingServiceProvider);
      final response = await coach.explainMove(_fen, _selectedMoveUci!);
      setState(() {
        _explanation = response;
      });
    } catch (e) {
      setState(() {
        _explanation = "Magnus Carlsen: Sorry, I couldn't explain that move right now. (Make sure your Gemini API key is configured).";
      });
    } finally {
      setState(() {
        _isLoading = false;
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
    final theme = Theme.of(context);
    final squaresState = _game.squaresState(0); // White at bottom
    
    // Get list of legal moves in the position
    final legalMoves = _game.generateLegalMoves();

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
                            onPressed: () => _updateFen(_fenController.text),
                            child: const Text('Load'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Recent games loader
                      if (_recentGames.isNotEmpty) ...[
                        DropdownButtonFormField<Game>(
                          decoration: const InputDecoration(
                            labelText: 'Load position from recent games',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          initialValue: _selectedRecentGame,
                          items: _recentGames.map((g) {
                            final dateStr = "${g.playedAt.day}/${g.playedAt.month}";
                            return DropdownMenuItem<Game>(
                              value: g,
                              child: Text('${g.mode.toUpperCase()} game - result: ${g.result} ($dateStr)'),
                            );
                          }).toList(),
                          onChanged: _onGameSelected,
                        ),
                        if (_selectedRecentGame != null && _selectedGameMoves.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: _selectedMovePly > 0
                                    ? () => _loadPlyPosition(_selectedMovePly - 1)
                                    : null,
                              ),
                              Expanded(
                                child: Text(
                                  'Move ${_selectedMovePly + 1} / ${_selectedGameMoves.length}: ${_selectedGameMoves[_selectedMovePly].san}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: _selectedMovePly < _selectedGameMoves.length - 1
                                    ? () => _loadPlyPosition(_selectedMovePly + 1)
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
                        theme: _getBoardTheme(context),
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
                      final san = _game.toSan(m);
                      
                      final fromStr = _game.size.squareName(m.from);
                      final toStr = _game.size.squareName(m.to);
                      String promoStr = '';
                      if (m.promotion && m.promoPiece != null) {
                        switch (m.promoPiece) {
                          case 2: promoStr = 'n'; break;
                          case 3: promoStr = 'b'; break;
                          case 4: promoStr = 'r'; break;
                          case 5: promoStr = 'q'; break;
                        }
                      }
                      final uci = '$fromStr$toStr$promoStr';
                      final isSelected = _selectedMoveUci == uci;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(san),
                          selected: isSelected,
                          selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                          onSelected: (_) => _onMoveSelected(m),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 16),

              // Explain Button
              ElevatedButton.icon(
                onPressed: _selectedMoveUci != null && !_isLoading ? _askMagnus : null,
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
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_explanation != null)
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
                          _explanation!,
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
