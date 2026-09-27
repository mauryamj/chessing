import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../game_setup_provider.dart';

class ConfigPanel extends ConsumerWidget {
  const ConfigPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(gameConfigProvider);
    final notifier = ref.read(gameConfigProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ??
            (isDark ? const Color(0xFF242424) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section title
          Row(
            children: [
              Icon(Icons.tune_rounded, size: 20, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                'Customize Rules & Difficulty',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Game Mode Selection
          Text(
            'Mode',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: GameMode.values.map((mode) {
              final isSelected = config.mode == mode;
              String title = '';
              IconData icon = Icons.play_arrow;
              String desc = '';
              switch (mode) {
                case GameMode.timed:
                  title = 'Timed';
                  icon = Icons.timer_outlined;
                  desc = 'With clock';
                  break;
                case GameMode.free:
                  title = 'Free';
                  icon = Icons.hourglass_empty_outlined;
                  desc = 'No limit';
                  break;
                case GameMode.level:
                  title = 'Level';
                  icon = Icons.trending_up_outlined;
                  desc = 'Bot power';
                  break;
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () => notifier.setMode(mode),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primaryContainer
                          : (isDark
                              ? const Color(0xFF1E1E1E)
                              : cs.surfaceContainerLowest),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? cs.primary
                            : cs.outlineVariant.withValues(alpha: 0.3),
                        width: isSelected ? 1.8 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          icon,
                          size: 20,
                          color: isSelected ? cs.primary : cs.onSurfaceVariant,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? cs.onPrimaryContainer
                                : cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? cs.onPrimaryContainer.withValues(alpha: 0.75)
                                : cs.onSurface.withValues(alpha: 0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),

          // Timed sub-options
          if (config.mode == GameMode.timed) ...[
            Text(
              'Time Control',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TimeControl.values.map((tc) {
                final isSelected = config.timeControl == tc;
                return ChoiceChip(
                  label: Text(tc.label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) notifier.setTimeControl(tc);
                  },
                  selectedColor: cs.primaryContainer,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? cs.onPrimaryContainer
                        : theme.textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
          ],

          // Level slider
          if (config.mode != GameMode.timed) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bot Difficulty',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Level ${config.botLevel}',
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E1E1E)
                    : cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.25),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: cs.primary,
                  inactiveTrackColor: cs.primary.withValues(alpha: 0.2),
                  thumbColor: cs.primary,
                  overlayColor: cs.primary.withValues(alpha: 0.12),
                  valueIndicatorColor: cs.primary,
                  valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                ),
                child: Slider(
                  value: config.botLevel.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: 'Level ${config.botLevel}',
                  onChanged: (val) {
                    notifier.setBotLevel(val.round());
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],

          // Color Picker
          Text(
            'Play As',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: PlayerColor.values.map((color) {
              final isSelected = config.playerColor == color;
              String label = '';
              IconData icon = Icons.circle;
              Color itemColor = Colors.white;
              switch (color) {
                case PlayerColor.white:
                  label = 'White';
                  icon = Icons.brightness_high_outlined;
                  itemColor = const Color(0xFFF0D9B5);
                  break;
                case PlayerColor.black:
                  label = 'Black';
                  icon = Icons.brightness_3_outlined;
                  itemColor = const Color(0xFFB58863);
                  break;
                case PlayerColor.random:
                  label = 'Random';
                  icon = Icons.shuffle;
                  itemColor = Colors.grey;
                  break;
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () => notifier.setPlayerColor(color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primaryContainer
                          : (isDark
                              ? const Color(0xFF1E1E1E)
                              : cs.surfaceContainerLowest),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? cs.primary
                            : cs.outlineVariant.withValues(alpha: 0.3),
                        width: isSelected ? 1.8 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          icon,
                          color: isSelected ? cs.primary : itemColor,
                          size: 24,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isSelected
                                ? cs.onPrimaryContainer
                                : cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),

          // Start Button
          ElevatedButton(
            onPressed: () {
              context.push('/board', extra: config.toJson());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded, size: 24),
                SizedBox(width: 6),
                Text(
                  'START CUSTOM GAME',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
