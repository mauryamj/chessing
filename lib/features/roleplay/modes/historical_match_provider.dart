import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bishop/bishop.dart' as bishop;
import '../../../core/ai/coaching_service.dart';
import '../../../core/pgn/pgn_parser.dart';
import '../models/historical_match_model.dart';

class HistoricalMatchState {
  final String? selectedGameId;
  final bishop.Game game;
  final List<String> moves;
  final int currentPly;
  final String? commentary;
  final bool isLoadingCommentary;

  HistoricalMatchState({
    this.selectedGameId,
    required this.game,
    this.moves = const [],
    this.currentPly = -1,
    this.commentary,
    this.isLoadingCommentary = false,
  });

  HistoricalMatchState copyWith({
    String? selectedGameId,
    bishop.Game? game,
    List<String>? moves,
    int? currentPly,
    String? commentary,
    bool clearCommentary = false,
    bool? isLoadingCommentary,
  }) {
    return HistoricalMatchState(
      selectedGameId: selectedGameId ?? this.selectedGameId,
      game: game ?? this.game,
      moves: moves ?? this.moves,
      currentPly: currentPly ?? this.currentPly,
      commentary: clearCommentary ? null : (commentary ?? this.commentary),
      isLoadingCommentary: isLoadingCommentary ?? this.isLoadingCommentary,
    );
  }
}

class HistoricalMatchNotifier extends StateNotifier<HistoricalMatchState> {
  final Ref _ref;

  HistoricalMatchNotifier(this._ref)
      : super(HistoricalMatchState(
          game: bishop.Game(variant: bishop.Variant.standard()),
        ));

  void selectGame(HistoricalMatchModel game) {
    state = state.copyWith(
      selectedGameId: game.id,
      moves: PgnParser.parseMoves(game.pgn),
      currentPly: -1,
      game: bishop.Game(variant: bishop.Variant.standard()),
      clearCommentary: true,
    );
  }

  void loadPly(int ply) {
    if (ply < -1 || ply >= state.moves.length) return;

    final bp = bishop.Game(variant: bishop.Variant.standard());
    for (int i = 0; i <= ply; i++) {
      final move = bp.getMoveSan(state.moves[i]);
      if (move != null) {
        bp.makeMove(move);
      } else {
        break;
      }
    }
    state = state.copyWith(
      currentPly: ply,
      game: bp,
      clearCommentary: true,
    );
  }

  Future<void> fetchCommentary(HistoricalMatchModel selectedGame) async {
    if (state.currentPly < 0) return;
    state = state.copyWith(
      isLoadingCommentary: true,
      clearCommentary: true,
    );

    try {
      final coach = _ref.read(coachingServiceProvider);
      final moveSan = state.moves[state.currentPly];
      final isWhiteMove = state.currentPly % 2 == 0;
      final playerName =
          isWhiteMove ? selectedGame.whitePlayer : selectedGame.blackPlayer;

      final tempBp = bishop.Game(variant: bishop.Variant.standard());
      for (int i = 0; i < state.currentPly; i++) {
        final move = tempBp.getMoveSan(state.moves[i]);
        if (move != null) tempBp.makeMove(move);
      }

      final response =
          await coach.commentMove(tempBp.fen, moveSan, playerName);
      state = state.copyWith(commentary: response);
    } catch (e) {
      state = state.copyWith(
        commentary: "Commentator: Could not load commentary for this move.",
      );
    } finally {
      state = state.copyWith(isLoadingCommentary: false);
    }
  }
}

final historicalMatchStateProvider = StateNotifierProvider.autoDispose<
    HistoricalMatchNotifier, HistoricalMatchState>((ref) {
  return HistoricalMatchNotifier(ref);
});
