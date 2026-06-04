import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/app_database.dart';
import '../../database/daos/games_dao.dart';
import '../../database/daos/profile_dao.dart';
import '../repositories/games_repository.dart';
import '../repositories/profile_repository.dart';
import '../supabase_client.dart';

class SyncService {
  final AppDatabase _db;
  final GamesRepository _gamesRepo = GamesRepository();
  final ProfileRepository _profileRepo = ProfileRepository();

  SyncService(this._db);

  // Called after login — pull cloud → local
  Future<void> pullFromCloud() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // Sync profile
      final remoteProfile = await _profileRepo.fetchProfile(userId);
      if (remoteProfile != null) {
        await _db.upsertProfileFromRemote(remoteProfile);
      }

      // Sync last 50 games (avoid full download on every login)
      final remoteGames = await _gamesRepo.fetchGames(limit: 50);
      for (final g in remoteGames) {
        await _db.upsertGameFromRemote(g);
      }
    } catch (e) {
      debugPrint('Error pulling from cloud: $e');
    }
  }

  // Called after each game ends — push local → cloud
  Future<void> pushGame(int localGameId) async {
    if (supabase.auth.currentUser == null) return; // offline, skip
    final game = await _db.getGameById(localGameId);
    if (game == null) return;
    try {
      final moves = await _db.getMovesForGame(localGameId);
      final remoteId = await _gamesRepo.uploadGame(game, moves);
      await _db.clearPendingSync(localGameId, remoteId);
    } catch (e) {
      debugPrint('Error pushing game to cloud: $e');
      await _db.markPendingSync(localGameId);
    }
  }

  // Called on app start — retry any previously failed uploads
  Future<void> retryPendingSync() async {
    if (supabase.auth.currentUser == null) return;
    try {
      final pending = await _db.getPendingSync();
      for (final game in pending) {
        await pushGame(game.id);
      }
    } catch (e) {
      debugPrint('Error retrying pending sync: $e');
    }
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(databaseProvider);
  return SyncService(db);
});
