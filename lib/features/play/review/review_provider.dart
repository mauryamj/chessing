import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/engine/stockfish_service.dart';

class ReviewMove {
  final int ply;
  final String uci;
  final String san;
  final int? eval; // centipawns from White's perspective
  final String? classification; // 'best'|'good'|'inaccuracy'|'mistake'|'blunder'
  final String? bestMoveUci;
  final String fen;
  final SquaresState squaresState;

  ReviewMove({
    required this.ply,
    required this.uci,
    required this.san,
    this.eval,
    this.classification,
    this.bestMoveUci,
    required this.fen,
    required this.squaresState,
  });
}

class ReviewState {
  final db.Game game;
  final List<ReviewMove> moves;
  final int currentPly; // -1 for initial position
  final bool isAnalyzing;
  final double analysisProgress;
  final int totalPlies;
  final int analyzedPlies;
  final String? error;
  final bool showBestMoveArrow;

  ReviewState({
    required this.game,
    required this.moves,
    required this.currentPly,
    required this.isAnalyzing,
    required this.analysisProgress,
    required this.totalPlies,
    required this.analyzedPlies,
    this.error,
    this.showBestMoveArrow = false,
  });

  SquaresState get currentSquaresState {
    if (currentPly == -1) {
      final bpGame = bishop.Game(variant: bishop.Variant.standard());
      return bpGame.squaresState(game.playerColorIndex);
    }
    return moves[currentPly].squaresState;
  }

  ReviewState copyWith({
    db.Game? game,
    List<ReviewMove>? moves,
    int? currentPly,
    bool? isAnalyzing,
    double? analysisProgress,
    int? totalPlies,
    int? analyzedPlies,
    String? error,
    bool? showBestMoveArrow,
  }) {
    return ReviewState(
      game: game ?? this.game,
      moves: moves ?? this.moves,
      currentPly: currentPly ?? this.currentPly,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      analysisProgress: analysisProgress ?? this.analysisProgress,
      totalPlies: totalPlies ?? this.totalPlies,
      analyzedPlies: analyzedPlies ?? this.analyzedPlies,
      error: error ?? this.error,
      showBestMoveArrow: showBestMoveArrow ?? this.showBestMoveArrow,
    );
  }
}

class ReviewNotifier extends StateNotifier<ReviewState> {
  final int gameId;
  final Ref ref;

  ReviewNotifier({required this.gameId, required this.ref})
      : super(ReviewState(
          game: db.Game(
            id: 0,
            pgn: '',
            result: '',
            mode: '',
            playedAt: DateTime.now(),
            playerColorIndex: 0,
            pendingSync: false,
          ),
          moves: [],
          currentPly: -1,
          isAnalyzing: false,
          analysisProgress: 0.0,
          totalPlies: 0,
          analyzedPlies: 0,
        )) {
    _loadGame();
  }

  Future<void> _loadGame() async {
    try {
      final database = ref.read(db.databaseProvider);
      final game = await database.getGameById(gameId);
      if (game == null) {
        state = state.copyWith(error: 'Game not found');
        return;
      }

      final dbMoves = await database.getMovesForGame(gameId);
      // Sort moves by ply
      final sortedDbMoves = [...dbMoves]..sort((a, b) => a.ply.compareTo(b.ply));

      // Re-create the board states at each ply using bishop
      final bpGame = bishop.Game(variant: bishop.Variant.standard());
      final List<ReviewMove> reviewMoves = [];

      for (int i = 0; i < sortedDbMoves.length; i++) {
        final dbMove = sortedDbMoves[i];
        final fenBefore = bpGame.fen;
        
        final sqMove = bpGame.squaresSize.moveFromAlgebraic(dbMove.uci);
        bpGame.makeSquaresMove(sqMove);

        final squaresState = bpGame.squaresState(game.playerColorIndex);

        reviewMoves.add(ReviewMove(
          ply: dbMove.ply,
          uci: dbMove.uci,
          san: dbMove.san,
          eval: dbMove.evalCentipawns,
          classification: dbMove.classification,
          bestMoveUci: dbMove.bestMoveUci,
          fen: fenBefore,
          squaresState: squaresState,
        ));
      }

      state = ReviewState(
        game: game,
        moves: reviewMoves,
        currentPly: -1,
        isAnalyzing: false,
        analysisProgress: 0.0,
        totalPlies: reviewMoves.length,
        analyzedPlies: reviewMoves.fold(0, (sum, m) => m.classification != null ? sum + 1 : sum),
      );

      // Check if we need to run Stockfish analysis
      final needsAnalysis = reviewMoves.any((m) => m.classification == null);
      if (needsAnalysis) {
        _runAnalysis();
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to load game: $e');
    }
  }

  Future<void> _runAnalysis() async {
    state = state.copyWith(isAnalyzing: true);

    try {
      final database = ref.read(db.databaseProvider);
      final engine = ref.read(stockfishServiceProvider);

      final List<ReviewMove> updatedMoves = [...state.moves];
      
      // Step 1: Analyze all positions.
      // We need to evaluate the starting FEN, and then the FEN after each move.
      // Let's build the FEN list.
      // FENs[0] is the starting FEN. FENs[i+1] is the FEN after move i.
      final List<String> fens = [];
      final bpGame = bishop.Game(variant: bishop.Variant.standard());
      fens.add(bpGame.fen);
      
      for (final m in state.moves) {
        final sqMove = bpGame.squaresSize.moveFromAlgebraic(m.uci);
        bpGame.makeSquaresMove(sqMove);
        fens.add(bpGame.fen);
      }

      // Analyze all positions sequentially.
      // E[i] is the evaluation of FENs[i] from White's perspective.
      final List<int> evals = List.filled(fens.length, 0);
      final List<String> bestMoves = List.filled(fens.length, '');

      final totalToAnalyze = fens.length;
      for (int i = 0; i < totalToAnalyze; i++) {
        final currentFen = fens[i];
        final bpTemp = bishop.Game(variant: bishop.Variant.standard(), fen: currentFen);
        
        int eval = 0;
        String bestMove = '';

        if (bpTemp.gameOver) {
          if (bpTemp.won) {
            eval = -10000;
          } else {
            eval = 0;
          }
        } else {
          final res = await engine.analyzePosition(currentFen, depth: 14);
          eval = res.eval;
          bestMove = res.bestMove;
        }

        // Convert eval to White's perspective
        // Stockfish returns eval from side to move's perspective.
        // bpTemp.turn: 0 is White, 1 is Black
        final whiteEval = bpTemp.turn == 0 ? eval : -eval;

        evals[i] = whiteEval;
        bestMoves[i] = bestMove;

        state = state.copyWith(
          analysisProgress: (i + 1) / totalToAnalyze,
          analyzedPlies: i + 1,
        );
      }

      // Step 2: Classify moves and update database
      int totalLoss = 0;
      int playerMovesCount = 0;

      for (int i = 0; i < state.moves.length; i++) {
        final m = state.moves[i];
        final whiteEvalBefore = evals[i];
        final whiteEvalAfter = evals[i + 1];

        // Loss from perspective of side to move
        final turn = i % 2;
        final loss = turn == 0
            ? (whiteEvalBefore - whiteEvalAfter)
            : (whiteEvalAfter - whiteEvalBefore);
        
        final clampedLoss = max(0, loss);
        
        String classification = 'best';
        if (clampedLoss <= 10) {
          classification = 'best';
        } else if (clampedLoss <= 50) {
          classification = 'good';
        } else if (clampedLoss <= 100) {
          classification = 'inaccuracy';
        } else if (clampedLoss <= 200) {
          classification = 'mistake';
        } else {
          classification = 'blunder';
        }

        final bestMoveUci = bestMoves[i];

        updatedMoves[i] = ReviewMove(
          ply: m.ply,
          uci: m.uci,
          san: m.san,
          eval: whiteEvalAfter,
          classification: classification,
          bestMoveUci: bestMoveUci,
          fen: m.fen,
          squaresState: m.squaresState,
        );

        await database.customStatement(
          'UPDATE moves SET eval_centipawns = ?, classification = ?, best_move_uci = ? WHERE game_id = ? AND ply = ?',
          [whiteEvalAfter, classification, bestMoveUci, gameId, m.ply],
        );

        if (turn == state.game.playerColorIndex) {
          playerMovesCount++;
          totalLoss += clampedLoss;
        }
      }

      int accuracy = 100;
      if (playerMovesCount > 0) {
        accuracy = max(0, 100 - (totalLoss ~/ (playerMovesCount * 2)));
      }

      await database.customStatement(
        'UPDATE games SET player_accuracy = ? WHERE id = ?',
        [accuracy, gameId],
      );

      final updatedGame = await database.getGameById(gameId);

      state = ReviewState(
        game: updatedGame ?? state.game,
        moves: updatedMoves,
        currentPly: state.currentPly,
        isAnalyzing: false,
        analysisProgress: 1.0,
        totalPlies: updatedMoves.length,
        analyzedPlies: updatedMoves.length,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Analysis failed: $e',
        isAnalyzing: false,
      );
    }
  }

  void stepForward() {
    if (state.currentPly < state.moves.length - 1) {
      state = state.copyWith(currentPly: state.currentPly + 1);
    }
  }

  void stepBackward() {
    if (state.currentPly > -1) {
      state = state.copyWith(currentPly: state.currentPly - 1);
    }
  }

  void goToPly(int ply) {
    if (ply >= -1 && ply < state.moves.length) {
      state = state.copyWith(currentPly: ply);
    }
  }

  void toggleBestMoveArrow() {
    state = state.copyWith(showBestMoveArrow: !state.showBestMoveArrow);
  }
}

final reviewStateProvider = StateNotifierProvider.family<ReviewNotifier, ReviewState, int>((ref, gameId) {
  return ReviewNotifier(gameId: gameId, ref: ref);
});
