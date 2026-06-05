import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/database/app_database.dart';
import '../../core/supabase/repositories/games_repository.dart';
import 'models/game_summary.dart';

part 'history_provider.g.dart';

enum HistoryFilter { all, wins, losses, draws }
enum HistorySort { recent, accuracy, longest }

// Alias for UI screen compatibility
typedef Game = GameSummary;

class HistoryState {
  final List<GameSummary> games;
  final bool hasMore;
  final HistoryFilter filter;
  final HistorySort sort;

  const HistoryState({
    required this.games,
    required this.hasMore,
    this.filter = HistoryFilter.all,
    this.sort = HistorySort.recent,
  });

  HistoryState copyWith({
    List<GameSummary>? games,
    bool? hasMore,
    HistoryFilter? filter,
    HistorySort? sort,
  }) =>
      HistoryState(
        games: games ?? this.games,
        hasMore: hasMore ?? this.hasMore,
        filter: filter ?? this.filter,
        sort: sort ?? this.sort,
      );

  List<GameSummary> get filtered {
    var list = games.where((g) {
      switch (filter) {
        case HistoryFilter.all:
          return true;
        case HistoryFilter.wins:
          return g.isWin;
        case HistoryFilter.losses:
          return g.isLoss;
        case HistoryFilter.draws:
          return g.isDraw;
      }
    }).toList();

    switch (sort) {
      case HistorySort.recent:
        list.sort((a, b) => b.playedAt.compareTo(a.playedAt));
        break;
      case HistorySort.accuracy:
        list.sort(
            (a, b) => (b.playerAccuracy ?? 0).compareTo(a.playerAccuracy ?? 0));
        break;
      case HistorySort.longest:
        list.sort(
            (a, b) => b.pgn.split(' ').length.compareTo(a.pgn.split(' ').length));
        break;
    }

    return list;
  }
}

@riverpod
class HistoryNotifier extends _$HistoryNotifier {
  @override
  Future<HistoryState> build() async {
    final repo = GamesRepository(
      ref.read(gamesDaoProvider),
      ref.read(cacheServiceProvider),
    );

    // Returns local DB first, background-refreshes if stale
    final games = await repo.get();

    return HistoryState(
      games: games,
      hasMore: games.length >= 50,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repo = GamesRepository(
      ref.read(gamesDaoProvider),
      ref.read(cacheServiceProvider),
    );
    try {
      final games = await repo.get(forceRefresh: true);
      state = AsyncValue.data(HistoryState(games: games, hasMore: games.length >= 50));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setFilter(HistoryFilter filter) {
    state = state.whenData((s) => s.copyWith(filter: filter));
  }

  void setSort(HistorySort sort) {
    state = state.whenData((s) => s.copyWith(sort: sort));
  }
}

// Compatibility provider for match_log_screen
final historyProvider = Provider<AsyncValue<HistoryState>>((ref) {
  return ref.watch(historyNotifierProvider);
});
