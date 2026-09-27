import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/streak_calculator.dart';
import '../../history/history_provider.dart';
import '../../profile/profile_provider.dart';
import 'game_setup_provider.dart';
import 'widgets/config_panel.dart';
import 'widgets/explore_section.dart';
import 'widgets/quick_play_hero.dart';
import 'widgets/recent_games_section.dart';
import 'widgets/stats_snapshot_row.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isConfigExpanded = false;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final config = ref.watch(gameConfigProvider);
    final profileAsync = ref.watch(profileNotifierProvider);
    final historyAsync = ref.watch(historyNotifierProvider);

    final profile = profileAsync.value;
    final games = historyAsync.value?.games ?? [];
    final streak = StreakCalculator.calculateStreak(
      games.map((g) => g.playedAt).toList(),
    );

    final username = (profile?.username.isNotEmpty ?? false)
        ? profile!.username
        : 'Player';

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        titleSpacing: 20,
        backgroundColor: cs.surface,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.6),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 1),
            Row(
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('👋', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
        actions: [
          // Streak badge
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: streak > 0
                  ? const Color(0xFFFF9800).withValues(alpha: 0.15)
                  : cs.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: streak > 0
                    ? const Color(0xFFFF9800).withValues(alpha: 0.4)
                    : cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🔥',
                  style: TextStyle(
                    fontSize: 13,
                    color: streak > 0 ? null : Colors.grey,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$streak${streak == 1 ? 'd' : 'd'}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: streak > 0
                        ? (isDark
                            ? const Color(0xFFFFB74D)
                            : const Color(0xFFE65100))
                        : cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Rating pill
          if (profile != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cs.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.military_tech_rounded,
                    size: 15,
                    color: cs.primary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${profile.currentRating}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 6),

          // Settings button
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: cs.onSurface.withValues(alpha: 0.75),
              size: 22,
            ),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.read(historyNotifierProvider.notifier).refresh(),
            ref.read(profileNotifierProvider.notifier).refresh(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Quick Play Hero Card
              QuickPlayHero(
                config: config,
                isConfigExpanded: _isConfigExpanded,
                onPlay: () {
                  context.push('/board', extra: config.toJson());
                },
                onToggleConfig: () {
                  setState(() {
                    _isConfigExpanded = !_isConfigExpanded;
                  });
                },
              ),

              // 2. Animated Collapsible Config Panel
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: ConfigPanel(),
                ),
                crossFadeState: _isConfigExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 280),
              ),
              const SizedBox(height: 20),

              // 3. Stats Snapshot Row (Wins, Accuracy, Total Games)
              StatsSnapshotRow(
                games: games,
                onTap: () => context.push('/history/performance'),
              ),
              const SizedBox(height: 24),

              // 4. Explore & Learn Section (Theory + AI Coaching)
              ExploreSection(
                onTheoryTap: () => context.go('/theory'),
                onCoachingTap: () => context.go('/roleplay'),
              ),
              const SizedBox(height: 24),

              // 5. Recent Matches Section
              RecentGamesSection(
                games: games,
                isLoading: historyAsync.isLoading,
                onGameTap: (game) {
                  final id = game.localId ?? game.remoteId;
                  if (id != null) {
                    context.push('/review/$id');
                  }
                },
                onViewAll: () => context.go('/history'),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
