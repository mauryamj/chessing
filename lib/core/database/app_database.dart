import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables/games_table.dart';
import 'tables/moves_table.dart';
import 'tables/profile_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Games, Moves, Profile])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // --- GAMES METHODS ---
  Future<int> insertGame(GamesCompanion game) => into(games).insert(game);
  
  Future<List<Game>> getAllGames() => select(games).get();
  
  Future<Game?> getGameById(int id) =>
      (select(games)..where((t) => t.id.equals(id))).getSingleOrNull();
  
  Future<List<Game>> getRecentGames(int limit) => (select(games)
        ..orderBy([(t) => OrderingTerm(expression: t.playedAt, mode: OrderingMode.desc)])
        ..limit(limit))
      .get();

  // --- MOVES METHODS ---
  Future<int> insertMove(MovesCompanion move) => into(moves).insert(move);
  
  Future<List<Move>> getMovesForGame(int gameId) =>
      (select(moves)..where((t) => t.gameId.equals(gameId))).get();

  // --- PROFILE METHODS ---
  Future<ProfileData?> getProfile() => select(profile).getSingleOrNull();
  
  Future<int> upsertProfile(ProfileCompanion data) =>
      into(profile).insertOnConflictUpdate(data);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'chess_app.db'));
    return NativeDatabase.createInBackground(file);
  });
}

// Provider to access database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
