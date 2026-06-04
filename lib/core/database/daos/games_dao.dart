import 'package:drift/drift.dart';
import '../app_database.dart';

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

  Future<void> upsertGameFromRemote(Map<String, dynamic> json) async {
    final remoteIdVal = json['id'] as String;
    final existing = await (select(games)..where((t) => t.remoteId.equals(remoteIdVal))).getSingleOrNull();
    if (existing != null) return; // already exists

    // Insert game
    final gameId = await into(games).insert(GamesCompanion.insert(
      pgn: json['pgn'] ?? '',
      result: json['result'] ?? '',
      mode: json['mode'] ?? '',
      botLevel: Value(json['bot_level']),
      timeControlSeconds: Value(json['time_control_seconds']),
      playedAt: json['played_at'] != null ? DateTime.parse(json['played_at']) : DateTime.now(),
      playerAccuracy: Value(json['player_accuracy']),
      remoteId: Value(remoteIdVal),
      pendingSync: const Value(false),
    ));

    // Insert moves if present in JSON
    final movesList = json['moves'] as List<dynamic>?;
    if (movesList != null) {
      for (final m in movesList) {
        await into(moves).insert(MovesCompanion.insert(
          gameId: gameId,
          ply: m['ply'] ?? 0,
          uci: m['uci'] ?? '',
          san: m['san'] ?? '',
          evalCentipawns: Value(m['eval_centipawns']),
          classification: Value(m['classification']),
        ));
      }
    }
  }
}
