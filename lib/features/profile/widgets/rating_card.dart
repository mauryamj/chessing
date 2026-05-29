import 'package:flutter/material.dart';
import '../../../core/database/app_database.dart';

class RatingCard extends StatelessWidget {
  final ProfileData profile;
  final List<Game> recentGames;

  const RatingCard({
    super.key,
    required this.profile,
    required this.recentGames,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Compute rating trend from last 10 games
    // We compare current rating to what it was 10 games ago.
    // Since we only have current + history, we estimate trend as
    // wins - losses in last 10 games (rough).
    int trend = 0;
    final last10 = recentGames.take(10).toList();
    for (final g in last10) {
      if (g.result == '1-0' && g.playerColorIndex == 0) trend++;
      if (g.result == '0-1' && g.playerColorIndex == 1) trend++;
      if (g.result == '1-0' && g.playerColorIndex == 1) trend--;
      if (g.result == '0-1' && g.playerColorIndex == 0) trend--;
    }

    final trendColor = trend > 0
        ? const Color(0xFF4CAF50)
        : trend < 0
            ? const Color(0xFFF44336)
            : cs.onSurface.withValues(alpha: 0.5);
    final trendIcon = trend > 0
        ? Icons.trending_up_rounded
        : trend < 0
            ? Icons.trending_down_rounded
            : Icons.trending_flat_rounded;
    final trendLabel = trend == 0 ? '±0' : '${trend > 0 ? '+' : ''}$trend';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primary,
            cs.primary.withValues(alpha: 0.75),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          // Big rating number
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rating',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${profile.currentRating}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 52,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(trendIcon, size: 16, color: trendColor),
                    const SizedBox(width: 4),
                    Text(
                      '$trendLabel (last 10)',
                      style: TextStyle(color: trendColor, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Peak rating
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Peak',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: Colors.white54)),
              const SizedBox(height: 2),
              Text(
                '${profile.peakRating}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${profile.gamesPlayed} games',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
