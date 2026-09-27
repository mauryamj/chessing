/// Utility to calculate player streak in days from game timestamps.
class StreakCalculator {
  /// Calculates the current consecutive day streak.
  /// If the player played today, today is included.
  /// If the player hasn't played today yet, yesterday is checked so the streak
  /// doesn't prematurely drop to 0 until the day ends.
  static int calculateStreak(List<DateTime> playedDates) {
    if (playedDates.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final daySet = playedDates
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

    DateTime currentCheck;
    if (daySet.contains(today)) {
      currentCheck = today;
    } else if (daySet.contains(yesterday)) {
      currentCheck = yesterday;
    } else {
      return 0;
    }

    int streak = 0;
    while (daySet.contains(currentCheck)) {
      streak++;
      currentCheck = currentCheck.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
