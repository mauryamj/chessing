import 'package:flutter/material.dart';
import '../../../history/models/game_summary.dart';

class StatsSnapshotRow extends StatelessWidget {
  final List<GameSummary> games;
  final VoidCallback? onTap;

  const StatsSnapshotRow({
    super.key,
    required this.games,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final totalGames = games.length;
    final wins = games.where((g) => g.isWin).length;
    final winRate = totalGames > 0 ? ((wins / totalGames) * 100).round() : 0;

    final accuracyGames = games.where((g) => g.playerAccuracy != null).toList();
    final avgAccuracy = accuracyGames.isNotEmpty
        ? (accuracyGames.fold<int>(0, (sum, g) => sum + (g.playerAccuracy ?? 0)) /
                accuracyGames.length)
            .round()
        : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ??
              (isDark ? const Color(0xFF262626) : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                icon: Icons.emoji_events_rounded,
                iconColor: const Color(0xFF4CAF50),
                value: '$wins',
                label: totalGames > 0 ? '$winRate% Rate' : 'Wins',
                title: 'Wins',
              ),
            ),
            Container(
              width: 1,
              height: 38,
              color: cs.outlineVariant.withValues(alpha: 0.25),
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.track_changes_rounded,
                iconColor: const Color(0xFFFFA000),
                value: avgAccuracy != null ? '$avgAccuracy%' : '--',
                label: 'Avg Score',
                title: 'Accuracy',
              ),
            ),
            Container(
              width: 1,
              height: 38,
              color: cs.outlineVariant.withValues(alpha: 0.25),
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.sports_esports_rounded,
                iconColor: cs.primary,
                value: '$totalGames',
                label: 'Total',
                title: 'Matches',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String title;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: cs.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}
