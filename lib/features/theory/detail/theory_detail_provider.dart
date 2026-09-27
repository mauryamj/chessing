import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bishop/bishop.dart' as bishop;
import 'package:square_bishop/square_bishop.dart';
import '../../../core/ai/coaching_service.dart';
import '../../../core/ai/prompts.dart';
import '../models/theory_entry.dart';

class TheoryDetailState {
  final bishop.Game game;
  final int currentPly;
  final List<String> currentLineMoves;
  final String? selectedVariationName;
  final String? aiExplanation;
  final bool isLoadingExplanation;

  TheoryDetailState({
    required this.game,
    this.currentPly = -1,
    this.currentLineMoves = const [],
    this.selectedVariationName,
    this.aiExplanation,
    this.isLoadingExplanation = false,
  });

  TheoryDetailState copyWith({
    bishop.Game? game,
    int? currentPly,
    List<String>? currentLineMoves,
    String? selectedVariationName,
    bool clearSelectedVariationName = false,
    String? aiExplanation,
    bool clearAiExplanation = false,
    bool? isLoadingExplanation,
  }) {
    return TheoryDetailState(
      game: game ?? this.game,
      currentPly: currentPly ?? this.currentPly,
      currentLineMoves: currentLineMoves ?? this.currentLineMoves,
      selectedVariationName: clearSelectedVariationName
          ? null
          : (selectedVariationName ?? this.selectedVariationName),
      aiExplanation:
          clearAiExplanation ? null : (aiExplanation ?? this.aiExplanation),
      isLoadingExplanation: isLoadingExplanation ?? this.isLoadingExplanation,
    );
  }
}

class TheoryDetailNotifier extends StateNotifier<TheoryDetailState> {
  final Ref _ref;

  TheoryDetailNotifier(this._ref)
      : super(TheoryDetailState(
          game: bishop.Game(variant: bishop.Variant.standard()),
        ));

  void initMainLine(TheoryEntry entry) {
    if (state.currentLineMoves.isEmpty) {
      state = state.copyWith(
        currentLineMoves: List.from(entry.moves),
        game: bishop.Game(variant: bishop.Variant.standard()),
        currentPly: -1,
      );
    }
  }

  void loadPly(int ply) {
    if (ply < -1 || ply >= state.currentLineMoves.length) return;

    final bp = bishop.Game(variant: bishop.Variant.standard());
    for (int i = 0; i <= ply; i++) {
      final sqMove = bp.squaresSize.moveFromAlgebraic(state.currentLineMoves[i]);
      bp.makeSquaresMove(sqMove);
    }

    state = state.copyWith(
      currentPly: ply,
      game: bp,
      clearAiExplanation: true,
    );
  }

  void loadVariation(TheoryEntry baseEntry, TheoryVariation variation) {
    final newLineMoves = [...baseEntry.moves, ...variation.moves];
    final startPly = baseEntry.moves.length - 1;

    final bp = bishop.Game(variant: bishop.Variant.standard());
    for (int i = 0; i <= startPly && i < newLineMoves.length; i++) {
      final sqMove = bp.squaresSize.moveFromAlgebraic(newLineMoves[i]);
      bp.makeSquaresMove(sqMove);
    }

    state = state.copyWith(
      selectedVariationName: variation.name,
      currentLineMoves: newLineMoves,
      currentPly: startPly,
      game: bp,
      clearAiExplanation: true,
    );
  }

  void resetToMainLine(TheoryEntry entry) {
    state = state.copyWith(
      clearSelectedVariationName: true,
      currentLineMoves: List.from(entry.moves),
      currentPly: -1,
      game: bishop.Game(variant: bishop.Variant.standard()),
      clearAiExplanation: true,
    );
  }

  Future<void> fetchAiCoachAdvice() async {
    state = state.copyWith(
      isLoadingExplanation: true,
      clearAiExplanation: true,
    );

    try {
      final coach = _ref.read(coachingServiceProvider);
      final response = await coach.ask(
        AiPrompts.theoryExplanationSystem,
        "Position FEN: ${state.game.fen}",
      );
      state = state.copyWith(aiExplanation: response);
    } catch (e) {
      state = state.copyWith(
        aiExplanation: "Unable to load coaching commentary. Check connection.",
      );
    } finally {
      state = state.copyWith(isLoadingExplanation: false);
    }
  }
}

final theoryDetailProvider = StateNotifierProvider.autoDispose
    .family<TheoryDetailNotifier, TheoryDetailState, String>((ref, theoryId) {
  return TheoryDetailNotifier(ref);
});
