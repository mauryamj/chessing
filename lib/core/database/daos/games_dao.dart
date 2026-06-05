import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../features/history/models/game_summary.dart';

extension GamesDao on AppDatabase {
  Future<List<Game>> getPendingSync() {
    return (select(games)..where((t) => t.pendingSync.equals(true))).get();
  }

  Future<void> markPendingSync(int localId) async {
    await (update(games)..where((t) => t.id.equals(localId))).write(
      const GamesCompanion(pendingSync: Value(true)),
    );
  }

  Future<void> clearPendingSync(int localId, String remoteId) async {
    await (update(games)..where((t) => t.id.equals(localId))).write(
      GamesCompanion(
        pendingSync: const Value(false),
        remoteId: Value(remoteId),
      ),
    );
  }

  Future<void> markSynced(int localId, String remoteId) async {
    await clearPendingSync(localId, remoteId);
  }

  Future<bool> existsByRemoteId(String remoteId) async {
    final game = await (select(games)..where((t) => t.remoteId.equals(remoteId))).getSingleOrNull();
    return game != null;
  }

  Future<List<GameSummary>> getCompletedGames({int limit = 50}) async {
    final rows = await (select(games)
          ..where((t) => t.isActive.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.playedAt)])
          ..limit(limit))
        .get();

    final List<GameSummary> summaries = [];
    for (final row in rows) {
      final moveRows = await getMovesForGame(row.id);
      summaries.add(GameSummary(
        remoteId: row.remoteId,
        localId: row.id,
        pgn: row.pgn,
        result: row.result,
        mode: row.mode,
        botLevel: row.botLevel,
        timeControlSeconds: row.timeControlSeconds,
        playerAccuracy: row.playerAccuracy,
        playerColorIndex: row.playerColorIndex,
        playedAt: row.playedAt,
        moves: moveRows
            .map((m) => MoveSummary(
                  ply: m.ply,
                  uci: m.uci,
                  san: m.san,
                  evalCentipawns: m.evalCentipawns,
                  classification: m.classification,
                  bestMoveUci: m.bestMoveUci,
                ))
            .toList(),
      ));
    }
    return summaries;
  }

  Future<void> insertFromRemote(GameSummary game) async {
    if (game.remoteId != null) {
      final exists = await existsByRemoteId(game.remoteId!);
      if (exists) return;
    }

    final localId = await into(games).insert(GamesCompanion.insert(
      remoteId: Value(game.remoteId),
      fen: const Value(''),
      pgn: game.pgn,
      result: game.result ?? '',
      mode: game.mode,
      botLevel: Value(game.botLevel),
      timeControlSeconds: Value(game.timeControlSeconds),
      playerAccuracy: Value(game.playerAccuracy),
      playedAt: game.playedAt,
      playerColorIndex: Value(game.playerColorIndex),
      pendingSync: const Value(false),
      isActive: const Value(false),
    ));

    for (final m in game.moves) {
      await into(moves).insert(MovesCompanion.insert(
        gameId: localId,
        ply: m.ply,
        uci: m.uci,
        san: m.san,
        evalCentipawns: Value(m.evalCentipawns),
        classification: Value(m.classification),
        bestMoveUci: Value(m.bestMoveUci),
      ));
    }
  }

  Future<void> upsertGameFromRemote(Map<String, dynamic> json) async {
    final summary = GameSummary.fromJson(json);
    await insertFromRemote(summary);
  }
}
