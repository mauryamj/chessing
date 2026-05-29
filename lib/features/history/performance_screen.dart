import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'history_provider.dart';
import 'widgets/rating_chart.dart';
import 'widgets/accuracy_chart.dart';

class PerformanceScreen extends ConsumerWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance'),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (history) {
          final games = history.games;

          // Summary stats
          int bestStreak = 0;
          int currentStreak = 0;
          for (final g in games.reversed) {
            final playerWon = g.result == '1-0' && g.playerColorIndex == 0 ||
                g.result == '0-1' && g.playerColorIndex == 1;
            if (playerWon) {
              currentStreak++;
              if (currentStreak > bestStreak) bestStreak = currentStreak;
            } else {
              currentStreak = 0;
            }
          }

          final accuracies = games
              .where((g) => g.playerAccuracy != null)
              .map((g) => g.playerAccuracy!)
              .toList();
          final avgAccuracy = accuracies.isEmpty
              ? 0
              : (accuracies.reduce((a, b) => a + b) / accuracies.length)
                  .round();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary stats row
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.star_rounded,
                      label: 'Best Streak',
                      value: '$bestStreak',
                      color: const Color(0xFFFFC107),
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      icon: Icons.precision_manufacturing_rounded,
                      label: 'Avg Accuracy',
                      value: '$avgAccuracy%',
                      color: cs.primary,
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      icon: Icons.sports_esports_rounded,
                      label: 'Total Games',
                      value: '${games.length}',
                      color: cs.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Rating chart
                _ChartCard(
                  title: 'Rating History',
                  child: RatingChart(games: games),
                ),
                const SizedBox(height: 20),

                // Accuracy chart
                _ChartCard(
                  title: 'Accuracy (Last 20 games)',
                  child: AccuracyChart(games: games),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
