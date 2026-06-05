import 'package:flutter/foundation.dart';
import '../supabase_client.dart';
import '../../database/daos/theory_dao.dart';
import '../../cache/cache_service.dart';
import '../../cache/offline_first_repository.dart';
import '../../../features/theory/models/theory_entry.dart';

class TheoryRepository with OfflineFirstRepository<TheoryEntry> {
  final TheoryDao _dao;
  final CacheService _cache;

  TheoryRepository(this._dao, this._cache);

  @override
  String get cacheKey => 'theory_entries';

  @override
  CacheService get cacheService => _cache;

  @override
  Future<List<TheoryEntry>> fetchFromLocal() => _dao.getAll();

  @override
  Future<List<TheoryEntry>> fetchFromRemote() async {
    final data = await supabase
        .from('theory_entries')
        .select()
        .order('sort_order');
    return data.map<TheoryEntry>(TheoryEntry.fromJson).toList();
  }

  @override
  Future<void> saveToLocal(List<TheoryEntry> items) => _dao.upsertAll(items);

  // --- User-specific data (bookmarks / progress) ---
  // These sync separately with their own TTL.

  Future<void> syncUserData() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    if (!await _cache.isStale('theory_user_data')) return;

    try {
      final bookmarks = await supabase
          .from('theory_bookmarks')
          .select('theory_id')
          .eq('user_id', userId);

      final completed = await supabase
          .from('theory_progress')
          .select('theory_id')
          .eq('user_id', userId);

      for (final b in bookmarks) {
        await _dao.setBookmark(b['theory_id'] as String, true);
      }
      for (final c in completed) {
        await _dao.setCompleted(c['theory_id'] as String);
      }

      await _cache.markFetched('theory_user_data', bookmarks.length + completed.length);
    } catch (e) {
      debugPrint('Theory user data sync failed: $e');
    }
  }

  Future<void> toggleBookmark(String theoryId) async {
    final existing = await _dao.getUserData(theoryId);
    final isBookmarked = existing?.isBookmarked ?? false;

    // Write local immediately — optimistic update
    await _dao.setBookmark(theoryId, !isBookmarked);

    // Push to Supabase in background if logged in
    if (supabase.auth.currentUser != null) {
      _pushBookmark(theoryId, !isBookmarked);
    }

    await _cache.invalidate('theory_user_data');
  }

  void _pushBookmark(String theoryId, bool value) async {
    try {
      if (value) {
        await supabase.from('theory_bookmarks').upsert({
          'user_id': supabase.auth.currentUser!.id,
          'theory_id': theoryId,
        });
      } else {
        await supabase.from('theory_bookmarks').delete()
            .eq('user_id', supabase.auth.currentUser!.id)
            .eq('theory_id', theoryId);
      }
    } catch (e) {
      debugPrint('Bookmark sync failed: $e — local state preserved');
    }
  }

  Future<void> markCompleted(String theoryId) async {
    await _dao.setCompleted(theoryId);
    if (supabase.auth.currentUser != null) {
      supabase.from('theory_progress').upsert({
        'user_id': supabase.auth.currentUser!.id,
        'theory_id': theoryId,
      }).catchError((e) => debugPrint('Progress sync failed: $e'));
    }
    await _cache.invalidate('theory_user_data');
  }
}
