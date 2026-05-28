import 'package:flutter/material.dart';
import '../review_provider.dart';

class BlunderMap extends StatelessWidget {
  final List<ReviewMove> moves;
  final Function(int) onPlySelected;

  const BlunderMap({
    super.key,
    required this.moves,
    required this.onPlySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Count classifications
    int best = 0;
    int good = 0;
    final List<int> inaccuracies = [];
    final List<int> mistakes = [];
    final List<int> blunders = [];

    for (int i = 0; i < moves.length; i++) {
      final classification = moves[i].classification;
      if (classification == 'best') {
        best++;
      } else if (classification == 'good') {
        good++;
      } else if (classification == 'inaccuracy') {
        inaccuracies.add(i);
      } else if (classification == 'mistake') {
        mistakes.add(i);
      } else if (classification == 'blunder') {
        blunders.add(i);
      }
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Classification counters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Best', best, Colors.green, theme),
                _buildStatColumn('Good', good, Colors.teal, theme),
                _buildStatColumn('Inacc.', inaccuracies.length, Colors.yellow[700]!, theme),
                _buildStatColumn('Mistake', mistakes.length, Colors.orange, theme),
                _buildStatColumn('Blunder', blunders.length, Colors.red, theme),
              ],
            ),
            
            // Jump to blunder/mistake section if any exist
            if (blunders.isNotEmpty || mistakes.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                'Jump to critical moments:',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...blunders.map((ply) {
                      final moveIndexLabel = ((ply + 2) ~/ 2);
                      final side = ply % 2 == 0 ? 'W' : 'B';
                      final san = moves[ply].san;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ActionChip(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.red.withValues(alpha: 0.08),
                          side: const BorderSide(color: Colors.red),
                          label: Text(
                            'Blunder: $moveIndexLabel. $side ($san)',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => onPlySelected(ply),
                        ),
                      );
                    }),
                    ...mistakes.map((ply) {
                      final moveIndexLabel = ((ply + 2) ~/ 2);
                      final side = ply % 2 == 0 ? 'W' : 'B';
                      final san = moves[ply].san;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ActionChip(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.orange.withValues(alpha: 0.08),
                          side: const BorderSide(color: Colors.orange),
                          label: Text(
                            'Mistake: $moveIndexLabel. $side ($san)',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => onPlySelected(ply),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String name, int count, Color color, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
