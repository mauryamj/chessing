import 'package:drift/drift.dart';
import '../app_database.dart';

extension ProfileDao on AppDatabase {
  Future<ProfileData?> getProfile() => select(profile).getSingleOrNull();

  Future<int> upsertProfile(ProfileCompanion data) =>
      into(profile).insertOnConflictUpdate(data);

  Future<void> updateRating({
    required int newRating,
    required bool isWin,
    required bool isDraw,
  }) async {
    final current = await getProfile();
    if (current == null) return;

    final newPeak =
        newRating > current.peakRating ? newRating : current.peakRating;
    final newWins = isWin ? current.wins + 1 : current.wins;
    final newDraws = isDraw ? current.draws + 1 : current.draws;
    final newLosses =
        (!isWin && !isDraw) ? current.losses + 1 : current.losses;

    await upsertProfile(ProfileCompanion(
      id: Value(current.id),
      username: Value(current.username),
      avatarPath: Value(current.avatarPath),
      currentRating: Value(newRating),
      peakRating: Value(newPeak),
      gamesPlayed: Value(current.gamesPlayed + 1),
      wins: Value(newWins),
      draws: Value(newDraws),
      losses: Value(newLosses),
      createdAt: Value(current.createdAt),
    ));
  }

  /// Ensure a profile row always exists (call on app startup).
  Future<void> ensureProfileExists() async {
    final existing = await getProfile();
    if (existing != null) return;
    await upsertProfile(ProfileCompanion.insert(
      createdAt: DateTime.now(),
    ));
  }
}
