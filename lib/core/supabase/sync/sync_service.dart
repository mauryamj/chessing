import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/app_database.dart';
import '../../database/daos/games_dao.dart';
import '../../database/daos/profile_dao.dart';
import '../repositories/games_repository.dart';
import '../repositories/profile_repository.dart';
import '../supabase_client.dart';
import '../../cache/cache_service.dart';

class SyncService {
  final AppDatabase _gamesDao;
  final GamesRepository _gamesRepo;
  final CacheService _cache;

  SyncService(this._gamesDao, this._gamesRepo, this._cache);

  // Called after login — pull cloud → local
  Future<void> pullFromCloud() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // Sync profile
      final profileRepo = ProfileRepository(_cache);
      final remoteProfile = await profileRepo.getProfile(forceRefresh: true);
      if (remoteProfile != null) {
        await _gamesDao.upsertProfileFromRemote({
          'id': remoteProfile.id,
          'username': remoteProfile.username,
          'avatar_url': remoteProfile.avatarUrl,
          'current_rating': remoteProfile.currentRating,
          'peak_rating': remoteProfile.peakRating,
          'games_played': remoteProfile.gamesPlayed,
          'wins': remoteProfile.wins,
          'draws': remoteProfile.draws,
          'losses': remoteProfile.losses,
        });
      }

      // Sync missing games
      await pullMissingGames();
    } catch (e) {
      debugPrint('Error pulling from cloud: $e');
    }
  }

  // Alias for compatibility with old code
  Future<void> pushGame(int localGameId) async {
    await pushCompletedGame(localGameId);
  }

  // Called after each game ends — upload to Supabase, keep local copy
  Future<void> pushCompletedGame(int localGameId) async {
    if (supabase.auth.currentUser == null) return;

    final game = await _gamesDao.getGameById(localGameId);
    if (game == null || game.remoteId != null) return; // already uploaded

    try {
      final moves = await _gamesDao.getMovesForGame(localGameId);
      final remoteId = await _gamesRepo.uploadGame(GameModel.fromDrift(game, moves));
      // Mark as synced — keep the local row as cache
      await _gamesDao.markSynced(localGameId, remoteId);
      // Invalidate history cache so it refreshes on next view
      await _cache.invalidate('match_history');
    } catch (e) {
      await _gamesDao.markPendingSync(localGameId);
      debugPrint('Game upload failed, queued for retry: $e');
    }
  }

  // On app start — retry any failed uploads
  Future<void> retryPendingSync() async {
    if (supabase.auth.currentUser == null) return;
    try {
      final pending = await _gamesDao.getPendingSync();
      for (final game in pending) {
        await pushCompletedGame(game.id);
      }
    } catch (e) {
      debugPrint('Error retrying pending sync: $e');
    }
  }

  // On login — pull remote games that are missing locally
  // (handles multi-device scenario: user played on another device)
  Future<void> pullMissingGames() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final remoteGames = await _gamesRepo.get(forceRefresh: true);
    for (final remote in remoteGames) {
      final exists = await _gamesDao.existsByRemoteId(remote.remoteId!);
      if (!exists) {
        await _gamesDao.insertFromRemote(remote);
      }
    }
    await _cache.markFetched('match_history', remoteGames.length);
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(databaseProvider);
  final repo = GamesRepository(db, ref.watch(cacheServiceProvider));
  final cache = ref.watch(cacheServiceProvider);
  return SyncService(db, repo, cache);
});
