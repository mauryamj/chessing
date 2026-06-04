import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings_provider.dart';

class GameplaySection extends ConsumerWidget {
  const GameplaySection({super.key});

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
        children: [
          // Show Legal Moves
          SwitchListTile(
            secondary: Icon(Icons.blur_on_rounded, color: cs.primary),
            title: const Text('Show Legal Moves'),
            subtitle: const Text('Highlights potential squares when tapping a piece'),
            value: settings.showLegalMoves,
            onChanged: notifier.setShowLegalMoves,
          ),
          const Divider(indent: 56, height: 1),

          // Show Threat Overlay
          SwitchListTile(
            secondary: Icon(Icons.shield_outlined, color: cs.primary),
            title: const Text('Default Threat HUD'),
            subtitle: const Text('Show squares attacked by opponent automatically'),
            value: settings.showThreatOverlay,
            onChanged: notifier.setShowThreatOverlay,
          ),
          const Divider(indent: 56, height: 1),

          // Auto Queen Promotion
          SwitchListTile(
            secondary: Icon(Icons.stars_rounded, color: cs.primary),
            title: const Text('Auto-Promote to Queen'),
            subtitle: const Text('Promote pawns to Queen automatically without prompt'),
            value: settings.autoQueenPromotion,
            onChanged: notifier.setAutoQueenPromotion,
          ),
          const Divider(indent: 56, height: 1),

          // Move Confirmation
          SwitchListTile(
            secondary: Icon(Icons.fact_check_outlined, color: cs.primary),
            title: const Text('Move Confirmation'),
            subtitle: const Text('Tap checkmark after placing a piece to confirm turn'),
            value: settings.moveConfirmation,
            onChanged: notifier.setMoveConfirmation,
          ),
        ],
      ),
    );
  }
}
