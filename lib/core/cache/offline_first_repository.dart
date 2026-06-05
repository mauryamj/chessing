import 'package:flutter/foundation.dart';
import 'cache_service.dart';

/// Mixin that implements the offline-first pattern for any repository.
/// T = the domain model type.
mixin OfflineFirstRepository<T> {
  CacheService get cacheService;

  // Subclass provides these four:
  Future<List<T>> fetchFromLocal();
  Future<List<T>> fetchFromRemote();
  Future<void> saveToLocal(List<T> items);
  String get cacheKey;

  /// Main entry point. Always returns cached data immediately if available,
  /// then refreshes in the background if stale.
  Future<List<T>> get({bool forceRefresh = false}) async {
    if (forceRefresh) {
      return await _fetchAndCache();
    }

    final hasCached = await cacheService.hasCache(cacheKey);

    // No cache at all → must fetch remotely and block
    if (!hasCached) {
      return await _fetchAndCache();
    }

    // Has cache → return it immediately
    final cached = await fetchFromLocal();

    // Check staleness in background — do not await
    if (await cacheService.isStale(cacheKey)) {
      _backgroundRefresh(); // fire and forget
    }

    return cached;
  }

  Future<List<T>> _fetchAndCache() async {
    final remote = await fetchFromRemote();
    await saveToLocal(remote);
    await cacheService.markFetched(cacheKey, remote.length);
    return remote;
  }

  void _backgroundRefresh() async {
    try {
      await _fetchAndCache();
    } catch (e) {
      // Silently swallow network errors during background refresh
      debugPrint('Background refresh failed for $cacheKey: $e');
    }
  }
}
