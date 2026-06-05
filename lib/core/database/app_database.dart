import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables/games_table.dart';
import 'tables/moves_table.dart';
import 'tables/profile_table.dart';
import 'tables/cache_meta_table.dart';
import 'tables/theory_entries_table.dart';
import 'tables/theory_user_data_table.dart';
import 'tables/historical_matches_table.dart';
import 'daos/theory_dao.dart';
import 'daos/historical_matches_dao.dart';
import '../cache/cache_service.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Games, Moves, Profile, CacheMeta, TheoryEntries, TheoryUserData, HistoricalMatches],
  daos: [TheoryDao, HistoricalMatchesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(games, games.playerColorIndex);
            await migrator.addColumn(moves, moves.bestMoveUci);
          }
          if (from < 3) {
            await migrator.addColumn(profile, profile.remoteId);
            await migrator.addColumn(games, games.remoteId);
            await migrator.addColumn(games, games.pendingSync);
          }
          if (from < 4) {
            await migrator.createTable(cacheMeta);
            await migrator.createTable(theoryEntries);
            await migrator.createTable(theoryUserData);
            await migrator.createTable(historicalMatches);
            await migrator.addColumn(games, games.fen);
            await migrator.addColumn(games, games.isActive);
          }
        },
      );

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

final cacheServiceProvider = Provider<CacheService>((ref) {
  final db = ref.watch(databaseProvider);
  return CacheService(db);
});

final theoryDaoProvider = Provider<TheoryDao>((ref) {
  return ref.watch(databaseProvider).theoryDao;
});

final historicalMatchesDaoProvider = Provider<HistoricalMatchesDao>((ref) {
  return ref.watch(databaseProvider).historicalMatchesDao;
});

final gamesDaoProvider = Provider<AppDatabase>((ref) {
  return ref.watch(databaseProvider);
});

