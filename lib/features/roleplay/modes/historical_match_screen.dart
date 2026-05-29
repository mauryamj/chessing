import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:squares/squares.dart' as sq;
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';
import '../../../core/ai/coaching_service.dart';
import '../../../core/pgn/pgn_parser.dart';
import '../../../app/theme.dart';

class HistoricalGame {
  final String title;
  final String players;
  final String assetPath;
  final String whitePlayer;
  final String blackPlayer;

  HistoricalGame({
    required this.title,
    required this.players,
    required this.assetPath,
    required this.whitePlayer,
    required this.blackPlayer,
  });
}

class HistoricalMatchScreen extends ConsumerStatefulWidget {
  const HistoricalMatchScreen({super.key});

  @override
  ConsumerState<HistoricalMatchScreen> createState() => _HistoricalMatchScreenState();
}

class _HistoricalMatchScreenState extends ConsumerState<HistoricalMatchScreen> {
  final List<HistoricalGame> _games = [
    HistoricalGame(
      title: "Fischer vs. Spassky (1972) - Game 6",
      players: "Bobby Fischer vs. Boris Spassky",
      assetPath: "assets/pgn/fischer_spassky_1972_g6.pgn",
      whitePlayer: "Bobby Fischer",
      blackPlayer: "Boris Spassky",
    ),
    HistoricalGame(
      title: "Deep Blue vs. Kasparov (1997) - Game 2",
      players: "Deep Blue vs. Garry Kasparov",
      assetPath: "assets/pgn/kasparov_deep_blue_1997_g2.pgn",
      whitePlayer: "Deep Blue",
      blackPlayer: "Garry Kasparov",
    ),
  ];

  late HistoricalGame _selectedGame;
  late bishop.Game _game;
  List<String> _moves = [];
  int _currentPly = -1; // -1 is starting position
  String? _commentary;
  bool _isLoadingCommentary = false;

  @override
  void initState() {
    super.initState();
    _selectedGame = _games.first;
    _game = bishop.Game(variant: bishop.Variant.standard());
    _loadGamePgn();
  }

  Future<void> _loadGamePgn() async {
    try {
      final pgnText = await DefaultAssetBundle.of(context).loadString(_selectedGame.assetPath);
      if (!mounted) return;
      final parsedMoves = PgnParser.parseMoves(pgnText);
      setState(() {
        _moves = parsedMoves;
        _currentPly = -1;
        _game = bishop.Game(variant: bishop.Variant.standard());
        _commentary = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load PGN: $e')),
      );
    }
  }

  void _loadPly(int ply) {
    if (ply < -1 || ply >= _moves.length) return;
    
    final bp = bishop.Game(variant: bishop.Variant.standard());
    for (int i = 0; i <= ply; i++) {
      final move = bp.getMoveSan(_moves[i]);
      if (move != null) {
        bp.makeMove(move);
      } else {
        break;
      }
    }
    setState(() {
      _currentPly = ply;
      _game = bp;
      _commentary = null;
    });
  }

  Future<void> _fetchCommentary() async {
    if (_currentPly < 0) return;
    setState(() {
      _isLoadingCommentary = true;
      _commentary = null;
    });

    try {
      final coach = ref.read(coachingServiceProvider);
      // The move played to get to the current state:
      final moveSan = _moves[_currentPly];
      final isWhiteMove = _currentPly % 2 == 0;
      final playerName = isWhiteMove ? _selectedGame.whitePlayer : _selectedGame.blackPlayer;
      
      // Pass the FEN of the state BEFORE the move was played
      final tempBp = bishop.Game(variant: bishop.Variant.standard());
      for (int i = 0; i < _currentPly; i++) {
        final move = tempBp.getMoveSan(_moves[i]);
        if (move != null) tempBp.makeMove(move);
      }

      final response = await coach.commentMove(tempBp.fen, moveSan, playerName);
      setState(() {
        _commentary = response;
      });
    } catch (e) {
      setState(() {
        _commentary = "Commentator: Could not load commentary for this move.";
      });
    } finally {
      setState(() {
        _isLoadingCommentary = false;
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
    final squaresState = _game.squaresState(0); // White orientation

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
                      DropdownButtonFormField<HistoricalGame>(
                        isExpanded: true,
                        initialValue: _selectedGame,
                        items: _games.map((g) {
                          return DropdownMenuItem<HistoricalGame>(
                            value: g,
                            child: Text(g.title),
                          );
                        }).toList(),
                        onChanged: (g) {
                          if (g != null) {
                            setState(() {
                              _selectedGame = g;
                            });
                            _loadGamePgn();
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
                        theme: _getBoardTheme(context),
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
                          ? 'Starting Position'
                          : 'Move ${(_currentPly + 2) ~/ 2} / ${(_moves.length + 1) ~/ 2}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _currentPly < _moves.length - 1 ? () => _loadPly(_currentPly + 1) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.last_page),
                    onPressed: _currentPly < _moves.length - 1 ? () => _loadPly(_moves.length - 1) : null,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Get Commentary Button
              ElevatedButton.icon(
                onPressed: _currentPly >= 0 && !_isLoadingCommentary ? _fetchCommentary : null,
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
              if (_isLoadingCommentary)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_commentary != null)
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
                          _commentary!,
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
  }
}
