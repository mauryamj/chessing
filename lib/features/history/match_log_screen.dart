import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'history_provider.dart';
import 'widgets/match_list_tile.dart';

class MatchLogScreen extends ConsumerWidget {
  const MatchLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyNotifierProvider);

    return Scaffold(
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (history) => RefreshIndicator(
          onRefresh: () => ref.read(historyNotifierProvider.notifier).refresh(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: const Text('Match History'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.bar_chart_rounded),
                    tooltip: 'Performance',
                    onPressed: () => context.push('/history/performance'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Refresh',
                    onPressed: () =>
                        ref.read(historyNotifierProvider.notifier).refresh(),
                  ),
                ],
              ),

              // Filter + Sort bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _FilterBarDelegate(
                  child: _FilterBar(history: history, ref: ref),
                ),
              ),

              // List
              if (history.filtered.isEmpty)
                SliverFillRemaining(
                  child: _EmptyState(filter: history.filter),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final game = history.filtered[index];
                        return MatchListTile(
                          game: game,
                          onTap: () => context.push('/review/${game.localId ?? game.remoteId}'),
                        );
                      },
                      childCount: history.filtered.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Filter bar ─────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final HistoryState history;
  final WidgetRef ref;

  const _FilterBar({required this.history, required this.ref});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final filters = [
      (HistoryFilter.all, 'All'),
      (HistoryFilter.wins, 'Wins'),
      (HistoryFilter.losses, 'Losses'),
      (HistoryFilter.draws, 'Draws'),
    ];
    final sorts = [
      (HistorySort.recent, 'Recent'),
      (HistorySort.accuracy, 'Accuracy'),
      (HistorySort.longest, 'Longest'),
    ];

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Filter chips
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((f) {
                  final selected = history.filter == f.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f.$2),
                      selected: selected,
                      onSelected: (_) => ref
                          .read(historyNotifierProvider.notifier)
                          .setFilter(f.$1),
                      selectedColor: cs.primaryContainer,
                      checkmarkColor: cs.primary,
                      labelStyle: TextStyle(
                        color:
                            selected ? cs.primary : cs.onSurface,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Sort dropdown
          PopupMenuButton<HistorySort>(
            icon: Icon(Icons.sort_rounded,
                color: cs.onSurface.withValues(alpha: 0.6)),
            tooltip: 'Sort',
            onSelected: (s) =>
                ref.read(historyNotifierProvider.notifier).setSort(s),
            itemBuilder: (_) => sorts
                .map((s) => PopupMenuItem(
                      value: s.$1,
                      child: Row(
                        children: [
                          if (history.sort == s.$1)
                            Icon(Icons.check_rounded,
                                size: 16, color: Theme.of(context).colorScheme.primary)
                          else
                            const SizedBox(width: 16),
                          const SizedBox(width: 8),
                          Text(s.$2),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _FilterBarDelegate({required this.child});

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;
  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(_FilterBarDelegate old) => old.child != child;
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final HistoryFilter filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final message = filter == HistoryFilter.all
        ? "You haven't played any games yet.\nStart a game to build your history!"
        : "No ${filter.name} games found.";

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 72,
              color: cs.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
