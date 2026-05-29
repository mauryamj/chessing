import 'package:flutter/material.dart';
import '../../../core/database/app_database.dart';

/// Each achievement milestone definition.
class _Achievement {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool Function(ProfileData, List<Game>) isUnlocked;

  const _Achievement({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isUnlocked,
  });
}

final _achievements = [
  _Achievement(
    id: 'first_win',
    icon: Icons.emoji_events_rounded,
    title: 'First Victory',
    subtitle: 'Win your first game',
    isUnlocked: (p, _) => p.wins >= 1,
  ),
  _Achievement(
    id: 'games_10',
    icon: Icons.sports_esports_rounded,
    title: 'Newcomer',
    subtitle: 'Play 10 games',
    isUnlocked: (p, _) => p.gamesPlayed >= 10,
  ),
  _Achievement(
    id: 'games_50',
    icon: Icons.local_fire_department_rounded,
    title: 'Veteran',
    subtitle: 'Play 50 games',
    isUnlocked: (p, _) => p.gamesPlayed >= 50,
  ),
  _Achievement(
    id: 'games_100',
    icon: Icons.military_tech_rounded,
    title: 'Centurion',
    subtitle: 'Play 100 games',
    isUnlocked: (p, _) => p.gamesPlayed >= 100,
  ),
  _Achievement(
    id: 'beat_level5',
    icon: Icons.psychology_rounded,
    title: 'Bot Slayer',
    subtitle: 'Beat a Level 5+ bot',
    isUnlocked: (_, games) => games.any((g) {
      final botWon = g.result == '1-0' && g.playerColorIndex == 0 ||
          g.result == '0-1' && g.playerColorIndex == 1;
      return !botWon && (g.botLevel ?? 0) >= 5;
    }),
  ),
  _Achievement(
    id: 'beat_level8',
    icon: Icons.whatshot_rounded,
    title: 'Master Breaker',
    subtitle: 'Beat a Level 8+ bot',
    isUnlocked: (_, games) => games.any((g) {
      final playerWon = g.result == '1-0' && g.playerColorIndex == 0 ||
          g.result == '0-1' && g.playerColorIndex == 1;
      return playerWon && (g.botLevel ?? 0) >= 8;
    }),
  ),
  _Achievement(
    id: 'streak_3',
    icon: Icons.bolt_rounded,
    title: 'Hat Trick',
    subtitle: 'Win 3 games in a row',
    isUnlocked: (_, games) => _hasWinStreak(games, 3),
  ),
  _Achievement(
    id: 'streak_5',
    icon: Icons.star_rounded,
    title: 'On Fire',
    subtitle: 'Win 5 games in a row',
    isUnlocked: (_, games) => _hasWinStreak(games, 5),
  ),
  _Achievement(
    id: 'streak_10',
    icon: Icons.auto_awesome_rounded,
    title: 'Unstoppable',
    subtitle: 'Win 10 games in a row',
    isUnlocked: (_, games) => _hasWinStreak(games, 10),
  ),
  _Achievement(
    id: 'accuracy_90',
    icon: Icons.precision_manufacturing_rounded,
    title: 'Sharpshooter',
    subtitle: 'Achieve ≥90% accuracy in a game',
    isUnlocked: (_, games) =>
        games.any((g) => (g.playerAccuracy ?? 0) >= 90),
  ),
];

bool _hasWinStreak(List<Game> games, int streak) {
  int current = 0;
  for (final g in games.reversed) {
    final playerWon = g.result == '1-0' && g.playerColorIndex == 0 ||
        g.result == '0-1' && g.playerColorIndex == 1;
    if (playerWon) {
      current++;
      if (current >= streak) return true;
    } else {
      current = 0;
    }
  }
  return false;
}

class AchievementsGrid extends StatelessWidget {
  final ProfileData profile;
  final List<Game> games;

  const AchievementsGrid({
    super.key,
    required this.profile,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.88,
      ),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final a = _achievements[index];
        final unlocked = a.isUnlocked(profile, games);
        return Tooltip(
          message: a.subtitle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: unlocked
                  ? cs.primaryContainer.withValues(alpha: 0.8)
                  : cs.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: unlocked
                    ? cs.primary.withValues(alpha: 0.5)
                    : cs.outline.withValues(alpha: 0.2),
              ),
              boxShadow: unlocked
                  ? [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : [],
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      a.icon,
                      size: 36,
                      color: unlocked
                          ? cs.primary
                          : cs.onSurface.withValues(alpha: 0.25),
                    ),
                    if (!unlocked)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          Icons.lock_rounded,
                          size: 14,
                          color: cs.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  a.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: unlocked
                        ? cs.onPrimaryContainer
                        : cs.onSurface.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
