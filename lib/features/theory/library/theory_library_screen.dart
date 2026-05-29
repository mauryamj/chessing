import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theory_provider.dart';
class TheoryLibraryScreen extends ConsumerWidget {
  const TheoryLibraryScreen({super.key});

  IconData _getIconForPhase(String phase) {
    switch (phase) {
      case 'opening':
        return Icons.grid_on;
      case 'middlegame':
        return Icons.flash_on;
      case 'endgame':
        return Icons.hourglass_empty;
      default:
        return Icons.book;
    }
  }

  Color _getColorForPhase(String phase, ThemeData theme) {
    switch (phase) {
      case 'opening':
        return Colors.blue;
      case 'middlegame':
        return Colors.orange;
      case 'endgame':
        return Colors.green;
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredEntriesAsyncValue = ref.watch(filteredTheoryEntriesProvider);
    final selectedCategory = ref.watch(theoryFilterCategoryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theory Library',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (val) => ref.read(theorySearchQueryProvider.notifier).state = val,
              decoration: InputDecoration(
                hintText: 'Search chess concepts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Categories chips row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildCategoryChip(ref, 'all', 'All Content', selectedCategory),
                  const SizedBox(width: 8),
                  _buildCategoryChip(ref, 'opening', 'Openings', selectedCategory),
                  const SizedBox(width: 8),
                  _buildCategoryChip(ref, 'middlegame', 'Middlegame', selectedCategory),
                  const SizedBox(width: 8),
                  _buildCategoryChip(ref, 'endgame', 'Endgames', selectedCategory),
                ],
              ),
            ),
          ),

          // Theory Entries list
          Expanded(
            child: filteredEntriesAsyncValue.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: theme.hintColor),
                        const SizedBox(height: 16),
                        Text(
                          'No concepts found',
                          style: theme.textTheme.titleMedium?.copyWith(color: theme.hintColor),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final phaseColor = _getColorForPhase(entry.phase, theme);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 1,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => context.push('/theory/${entry.id}'),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: phaseColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getIconForPhase(entry.phase),
                                  color: phaseColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            entry.title,
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: phaseColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: phaseColor.withValues(alpha: 0.3)),
                                          ),
                                          child: Text(
                                            entry.phase.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: phaseColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      entry.summary,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      children: entry.keyIdeas.take(2).map((idea) {
                                        return Chip(
                                          label: Text(
                                            idea,
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                          padding: EdgeInsets.zero,
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Error loading theory: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(WidgetRef ref, String category, String label, String selectedCategory) {
    final isSelected = selectedCategory == category;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          ref.read(theoryFilterCategoryProvider.notifier).state = category;
        }
      },
    );
  }
}
