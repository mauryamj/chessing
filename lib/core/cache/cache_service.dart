import 'package:drift/drift.dart';
import '../database/app_database.dart';

class CacheService {
  final AppDatabase _db;

  CacheService(this._db);

  static const _ttls = {
    'theory_entries':     Duration(days: 7),
    'historical_matches': Duration(days: 30),
    'profile':            Duration(hours: 1),
    'match_history':      Duration(minutes: 15),
    'theory_user_data':   Duration(minutes: 5),
  };

  /// Returns true if cache is empty OR past its TTL.
  Future<bool> isStale(String key) async {
    final meta = await (_db.select(_db.cacheMeta)
        ..where((t) => t.key.equals(key)))
        .getSingleOrNull();

    if (meta == null) return true;  // never fetched — definitely stale

    final ttl = _ttls[key] ?? const Duration(hours: 1);
    return DateTime.now().isAfter(meta.lastFetchedAt.add(ttl));
  }

  /// Returns true if the local cache has ANY records for this key.
  Future<bool> hasCache(String key) async {
    final meta = await (_db.select(_db.cacheMeta)
        ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return meta != null && meta.recordCount > 0;
  }

  /// Call after a successful fetch to update the timestamp.
  Future<void> markFetched(String key, int recordCount) async {
    await _db.into(_db.cacheMeta).insertOnConflictUpdate(
      CacheMetaCompanion.insert(
        key: key,
        lastFetchedAt: DateTime.now(),
        recordCount: Value(recordCount),
      ),
    );
  }

  /// Force-expire a key so next access triggers a refresh.
  Future<void> invalidate(String key) async {
    await (_db.update(_db.cacheMeta)
        ..where((t) => t.key.equals(key)))
        .write(CacheMetaCompanion(
          lastFetchedAt: Value(DateTime(2000)),  // epoch-ish = always stale
        ));
  }
}
