import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';
import '../../../core/ai/coaching_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/chess_move_utils.dart';

class WhyThisMoveState {
  final bishop.Game game;
  final String fen;
  final List<Game> recentGames;
  final Game? selectedRecentGame;
  final List<Move> selectedGameMoves;
  final int selectedMovePly;
  final String? selectedMoveUci;
  final String? explanation;
  final bool isLoading;
  final String? errorMessage;

  WhyThisMoveState({
    required this.game,
    required this.fen,
    this.recentGames = const [],
    this.selectedRecentGame,
    this.selectedGameMoves = const [],
    this.selectedMovePly = 0,
    this.selectedMoveUci,
    this.explanation,
    this.isLoading = false,
    this.errorMessage,
  });

  WhyThisMoveState copyWith({
    bishop.Game? game,
    String? fen,
    List<Game>? recentGames,
    Game? selectedRecentGame,
    bool clearSelectedRecentGame = false,
    List<Move>? selectedGameMoves,
    int? selectedMovePly,
    String? selectedMoveUci,
    bool clearSelectedMoveUci = false,
    String? explanation,
    bool clearExplanation = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return WhyThisMoveState(
      game: game ?? this.game,
      fen: fen ?? this.fen,
      recentGames: recentGames ?? this.recentGames,
      selectedRecentGame:
          clearSelectedRecentGame ? null : (selectedRecentGame ?? this.selectedRecentGame),
      selectedGameMoves: selectedGameMoves ?? this.selectedGameMoves,
      selectedMovePly: selectedMovePly ?? this.selectedMovePly,
      selectedMoveUci: clearSelectedMoveUci ? null : (selectedMoveUci ?? this.selectedMoveUci),
      explanation: clearExplanation ? null : (explanation ?? this.explanation),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class WhyThisMoveNotifier extends StateNotifier<WhyThisMoveState> {
  final Ref _ref;

  static const String defaultFen =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  WhyThisMoveNotifier(this._ref)
      : super(WhyThisMoveState(
          game: bishop.Game(
            variant: bishop.Variant.standard(),
            fen: defaultFen,
          ),
          fen: defaultFen,
        ));

  Future<void> loadRecentGames() async {
    try {
      final db = _ref.read(databaseProvider);
      final games = await db.getRecentGames(5);
      state = state.copyWith(recentGames: games);
    } catch (_) {}
  }

  Future<void> onGameSelected(Game? game) async {
    if (game == null) return;
    try {
      final db = _ref.read(databaseProvider);
      final moves = await db.getMovesForGame(game.id);
      final sortedMoves = [...moves]..sort((a, b) => a.ply.compareTo(b.ply));

      state = state.copyWith(
        selectedRecentGame: game,
        selectedGameMoves: sortedMoves,
        selectedMovePly: 0,
      );

      if (sortedMoves.isNotEmpty) {
        loadPlyPosition(0);
      }
    } catch (_) {}
  }

  void loadPlyPosition(int plyIndex) {
    if (state.selectedGameMoves.isEmpty ||
        plyIndex < 0 ||
        plyIndex >= state.selectedGameMoves.length) {
      return;
    }

    final bp = bishop.Game(variant: bishop.Variant.standard());
    for (int i = 0; i < plyIndex; i++) {
      final sqMove = bp.squaresSize.moveFromAlgebraic(state.selectedGameMoves[i].uci);
      bp.makeSquaresMove(sqMove);
    }

    final currentUci = state.selectedGameMoves[plyIndex].uci;

    state = state.copyWith(
      fen: bp.fen,
      game: bp,
      selectedMoveUci: currentUci,
      selectedMovePly: plyIndex,
      clearExplanation: true,
    );
  }

  bool updateFen(String newFen) {
    try {
      final bp = bishop.Game(variant: bishop.Variant.standard(), fen: newFen);
      state = state.copyWith(
        fen: newFen,
        game: bp,
        clearSelectedMoveUci: true,
        clearExplanation: true,
        clearSelectedRecentGame: true,
        clearErrorMessage: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Invalid FEN position: $e');
      return false;
    }
  }

  void selectMove(bishop.Move m) {
    final uci = ChessMoveUtils.toUci(state.game, m);
    state = state.copyWith(
      selectedMoveUci: uci,
      clearExplanation: true,
    );
  }

  Future<void> askMagnus() async {
    if (state.selectedMoveUci == null) return;
    state = state.copyWith(
      isLoading: true,
      clearExplanation: true,
    );

    try {
      final coach = _ref.read(coachingServiceProvider);
      final response = await coach.explainMove(state.fen, state.selectedMoveUci!);
      state = state.copyWith(explanation: response);
    } catch (e) {
      state = state.copyWith(
        explanation:
            "Magnus Carlsen: Sorry, I couldn't explain that move right now. (Make sure your Gemini API key is configured).",
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }
}

final whyThisMoveProvider =
    StateNotifierProvider.autoDispose<WhyThisMoveNotifier, WhyThisMoveState>((ref) {
  final notifier = WhyThisMoveNotifier(ref);
  notifier.loadRecentGames();
  return notifier;
});
