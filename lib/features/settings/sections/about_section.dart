import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.info_outline_rounded, color: cs.primary),
          title: const Text('Chessing'),
          subtitle: const Text('Version 0.2.0 · Built with Flutter & Supabase'),
        ),
        const Divider(indent: 56, height: 1),
        ListTile(
          leading: Icon(Icons.psychology_alt_rounded, color: cs.primary),
          title: const Text('AI Coaching'),
          subtitle: const Text('Powered by Gemini 3.5 Flash'),
        ),
        const Divider(indent: 56, height: 1),
        ListTile(
          leading: Icon(Icons.star_rate_rounded, color: cs.primary),
          title: const Text('Rate the App'),
          subtitle: const Text('Support development by leaving a rating on App Store'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('App Store rating coming soon!')),
            );
          },
        ),
        const Divider(indent: 56, height: 1),
        ListTile(
          leading: Icon(Icons.feedback_rounded, color: cs.primary),
          title: const Text('Send Feedback'),
          subtitle: const Text('Help us improve by sending feature requests'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thank you! Feedback service coming soon.')),
            );
          },
        ),
      ],
    );
  }
}
