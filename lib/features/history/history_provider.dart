import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';

enum HistoryFilter { all, wins, losses, draws }
enum HistorySort { recent, accuracy, longest }

class HistoryState {
  final List<Game> games;
  final HistoryFilter filter;
  final HistorySort sort;

  const HistoryState({
    required this.games,
    this.filter = HistoryFilter.all,
    this.sort = HistorySort.recent,
  });

  HistoryState copyWith({
    List<Game>? games,
    HistoryFilter? filter,
    HistorySort? sort,
  }) =>
      HistoryState(
        games: games ?? this.games,
        filter: filter ?? this.filter,
        sort: sort ?? this.sort,
      );

  List<Game> get filtered {
    var list = games.where((g) {
      switch (filter) {
        case HistoryFilter.all:
          return true;
        case HistoryFilter.wins:
          return g.result == '1-0' && g.playerColorIndex == 0 ||
              g.result == '0-1' && g.playerColorIndex == 1;
        case HistoryFilter.losses:
          return g.result == '0-1' && g.playerColorIndex == 0 ||
              g.result == '1-0' && g.playerColorIndex == 1;
        case HistoryFilter.draws:
          return g.result == '1/2-1/2';
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
        // Proxy: number of moves in PGN — we count spaces/tokens
        list.sort(
            (a, b) => b.pgn.split(' ').length.compareTo(a.pgn.split(' ').length));
        break;
    }

    return list;
  }
}

class HistoryNotifier extends StateNotifier<AsyncValue<HistoryState>> {
  final AppDatabase _db;

  HistoryNotifier(this._db) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final games = await _db.getAllGames();
      state = AsyncValue.data(HistoryState(games: games));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setFilter(HistoryFilter filter) {
    state.whenData((s) => state = AsyncValue.data(s.copyWith(filter: filter)));
  }

  void setSort(HistorySort sort) {
    state.whenData((s) => state = AsyncValue.data(s.copyWith(sort: sort)));
  }

  Future<void> refresh() => _load();
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<HistoryState>>((ref) {
  final db = ref.watch(databaseProvider);
  return HistoryNotifier(db);
});
