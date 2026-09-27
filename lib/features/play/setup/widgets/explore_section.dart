import 'package:flutter/material.dart';

class ExploreSection extends StatelessWidget {
  final VoidCallback onTheoryTap;
  final VoidCallback onCoachingTap;

  const ExploreSection({
    super.key,
    required this.onTheoryTap,
    required this.onCoachingTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Train & Explore',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Theory Card
            Expanded(
              child: _ExploreCard(
                title: 'Theory Library',
                subtitle: 'Openings & tactics',
                icon: Icons.menu_book_rounded,
                accentColor: cs.secondary,
                backgroundColor: isDark
                    ? cs.secondary.withValues(alpha: 0.15)
                    : cs.secondary.withValues(alpha: 0.1),
                onTap: onTheoryTap,
              ),
            ),
            const SizedBox(width: 12),
            // Coaching Card
            Expanded(
              child: _ExploreCard(
                title: 'AI Coaching',
                subtitle: 'Grandmaster feedback',
                icon: Icons.psychology_rounded,
                accentColor: const Color(0xFF7C4DFF),
                backgroundColor: isDark
                    ? const Color(0xFF7C4DFF).withValues(alpha: 0.15)
                    : const Color(0xFF7C4DFF).withValues(alpha: 0.08),
                onTap: onCoachingTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _ExploreCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
