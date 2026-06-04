import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings_provider.dart';

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (settings) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theme segmented selection
          ListTile(
            leading: Icon(
              settings.themeMode == ThemeMode.dark
                  ? Icons.dark_mode_rounded
                  : (settings.themeMode == ThemeMode.light ? Icons.light_mode_rounded : Icons.brightness_auto_rounded),
              color: cs.primary,
            ),
            title: const Text('Theme'),
            subtitle: Text(
              settings.themeMode == ThemeMode.dark
                  ? 'Always Dark'
                  : (settings.themeMode == ThemeMode.light ? 'Always Light' : 'Follows System'),
            ),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12),
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (mode) {
                if (mode != null) notifier.setThemeMode(mode);
              },
            ),
          ),
          const Divider(indent: 56, height: 1),

          // Piece Set Selection
          ListTile(
            leading: Icon(Icons.style_outlined, color: cs.primary),
            title: const Text('Piece Style'),
            subtitle: Text(settings.pieceSet.label),
            trailing: DropdownButton<PieceSetType>(
              value: settings.pieceSet,
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12),
              items: PieceSetType.values.map((set) {
                return DropdownMenuItem(value: set, child: Text(set.label));
              }).toList(),
              onChanged: (set) {
                if (set != null) notifier.setPieceSet(set);
              },
            ),
          ),
        ],
      ),
    );
  }
}
