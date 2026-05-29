import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/database/daos/profile_dao.dart';

/// Provides the current user profile, auto-refreshes when notified.
final profileProvider = FutureProvider<ProfileData?>((ref) async {
  final db = ref.watch(databaseProvider);
  await db.ensureProfileExists();
  return db.getProfile();
});

/// Provides the list of all games (for stats derivation).
final allGamesProvider = FutureProvider<List<Game>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getAllGames();
});

/// Notifier that allows the profile screen to mutate username and refresh.
class ProfileNotifier extends StateNotifier<AsyncValue<ProfileData?>> {
  final AppDatabase _db;

  ProfileNotifier(this._db) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      await _db.ensureProfileExists();
      final data = await _db.getProfile();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUsername(String name) async {
    final current = state.value;
    if (current == null) return;
    await _db.upsertProfile(ProfileCompanion(
      id: Value(current.id),
      username: Value(name.trim().isEmpty ? 'Player' : name.trim()),
    ));
    await _load();
  }

  Future<void> refresh() => _load();
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileData?>>((ref) {
  final db = ref.watch(databaseProvider);
  return ProfileNotifier(db);
});
