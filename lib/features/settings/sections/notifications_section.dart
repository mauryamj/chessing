import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings_provider.dart';

class NotificationsSection extends ConsumerWidget {
  const NotificationsSection({super.key});

  Future<void> _selectTime(BuildContext context, SettingsNotifier notifier, TimeOfDay initialTime) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime != null) {
      await notifier.setDailyReminderTime(pickedTime);
    }
  }

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
          // Daily reminder toggle
          SwitchListTile(
            secondary: Icon(Icons.notifications_active_outlined, color: cs.primary),
            title: const Text('Daily Reminder'),
            subtitle: const Text('Notify me daily to play and practice chess'),
            value: settings.dailyReminderEnabled,
            onChanged: notifier.setDailyReminderEnabled,
          ),
          
          if (settings.dailyReminderEnabled) ...[
            const Divider(indent: 56, height: 1),
            ListTile(
              leading: const SizedBox(width: 24), // alignment spacer
              title: const Text('Reminder Time'),
              subtitle: Text(settings.dailyReminderTime.format(context)),
              trailing: const Icon(Icons.access_time_rounded),
              onTap: () => _selectTime(context, notifier, settings.dailyReminderTime),
            ),
          ],

          const Divider(indent: 56, height: 1),

          // Achievement Notifications
          SwitchListTile(
            secondary: Icon(Icons.emoji_events_outlined, color: cs.primary),
            title: const Text('Achievement Notifications'),
            subtitle: const Text('Get notified when unlocking milestone badges'),
            value: settings.achievementNotifications,
            onChanged: notifier.setAchievementNotifications,
          ),
        ],
      ),
    );
  }
}
