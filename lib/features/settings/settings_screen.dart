import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: cs.surface,
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          children: [
            // ── Appearance ──────────────────────────────────────────────────
            const _SectionHeader(label: 'Appearance'),
            _SettingsCard(
              children: [
                // Theme Mode
                Semantics(
                  label: 'Theme mode selector',
                  child: ListTile(
                    leading: Semantics(
                      excludeSemantics: true,
                      child: Icon(
                        _themeModeIcon(settings.themeMode),
                        color: cs.primary,
                      ),
                    ),
                    title: const Text('Theme'),
                    subtitle: Text(_themeModeLabel(settings.themeMode)),
                    trailing: DropdownButton<ThemeMode>(
                      value: settings.themeMode,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(12),
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('System'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Dark'),
                        ),
                      ],
                      onChanged: (m) {
                        if (m != null) notifier.setThemeMode(m);
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Board Theme ─────────────────────────────────────────────────
            const _SectionHeader(label: 'Board Theme'),
            _BoardThemeGrid(
              selected: settings.boardTheme,
              onSelected: notifier.setBoardTheme,
            ),

            const SizedBox(height: 16),

            // ── Sound & Haptics ─────────────────────────────────────────────
            const _SectionHeader(label: 'Sound & Haptics'),
            _SettingsCard(
              children: [
                Semantics(
                  label: 'Sound effects toggle',
                  toggled: settings.soundEnabled,
                  child: SwitchListTile(
                    secondary: Semantics(
                      excludeSemantics: true,
                      child: Icon(
                        settings.soundEnabled
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        color: cs.primary,
                      ),
                    ),
                    title: const Text('Sound Effects'),
                    subtitle: const Text('Move, capture & clock sounds'),
                    value: settings.soundEnabled,
                    onChanged: notifier.setSound,
                  ),
                ),
                const Divider(height: 1, indent: 56),
                Semantics(
                  label: 'Haptics feedback toggle',
                  toggled: settings.hapticsEnabled,
                  child: SwitchListTile(
                    secondary: Semantics(
                      excludeSemantics: true,
                      child: Icon(
                        settings.hapticsEnabled
                            ? Icons.vibration_rounded
                            : Icons.phone_android_rounded,
                        color: cs.primary,
                      ),
                    ),
                    title: const Text('Haptic Feedback'),
                    subtitle: const Text('Light tap on move, strong on check'),
                    value: settings.hapticsEnabled,
                    onChanged: notifier.setHaptics,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── About ───────────────────────────────────────────────────────
            const _SectionHeader(label: 'About'),
            _SettingsCard(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: cs.primary),
                  title: const Text('Chessing'),
                  subtitle: const Text('Version 0.1.0 · Built with Flutter & Stockfish'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(Icons.psychology_alt_rounded, color: cs.primary),
                  title: const Text('AI Coaching'),
                  subtitle: const Text('Powered by Gemini 2.5 Flash'),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  IconData _themeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Always light';
      case ThemeMode.dark:
        return 'Always dark';
      case ThemeMode.system:
        return 'Follows system preference';
    }
  }
}

// ── Board theme grid ──────────────────────────────────────────────────────────

class _BoardThemeGrid extends StatelessWidget {
  final BoardThemeType selected;
  final ValueChanged<BoardThemeType> onSelected;

  const _BoardThemeGrid({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: BoardThemeType.values.map((t) {
        final isSelected = t == selected;
        final colors = _previewColors(t, theme.brightness);

        return Semantics(
          label: '${t.label} board theme${isSelected ? ", selected" : ""}',
          button: true,
          child: GestureDetector(
            onTap: () => onSelected(t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: theme.cardTheme.color ?? cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? cs.primary : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: cs.shadow.withValues(alpha: 0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mini board preview (2×2 squares)
                  Expanded(
                    child: Center(
                      child: _MiniBoardPreview(
                        light: colors.$1,
                        dark: colors.$2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(t.icon, size: 14, color: cs.primary),
                      const SizedBox(width: 4),
                      Text(
                        t.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? cs.primary
                              : cs.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                      if (isSelected) ...[
                        const Spacer(),
                        Icon(Icons.check_circle_rounded,
                            size: 14, color: cs.primary),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  (Color, Color) _previewColors(BoardThemeType type, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (type) {
      case BoardThemeType.classic:
        return isDark
            ? (const Color(0xFFECECD7), const Color(0xFF739552))
            : (const Color(0xFFF0D9B5), const Color(0xFFB58863));
      case BoardThemeType.wood:
        return isDark
            ? (const Color(0xFFC8A87A), const Color(0xFF6B3410))
            : (const Color(0xFFDEB887), const Color(0xFF8B4513));
      case BoardThemeType.neon:
        return (const Color(0xFF1A1A2E), const Color(0xFF16213E));
      case BoardThemeType.minimal:
        return isDark
            ? (const Color(0xFF424242), const Color(0xFF212121))
            : (const Color(0xFFF5F5F5), const Color(0xFF9E9E9E));
    }
  }
}

class _MiniBoardPreview extends StatelessWidget {
  final Color light;
  final Color dark;

  const _MiniBoardPreview({required this.light, required this.dark});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: GridView.count(
          crossAxisCount: 4,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: List.generate(16, (i) {
            final row = i ~/ 4;
            final col = i % 4;
            final isLight = (row + col) % 2 == 0;
            return ColoredBox(color: isLight ? light : dark);
          }),
        ),
      ),
    );
  }
}

// ── Shared UI helpers ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
