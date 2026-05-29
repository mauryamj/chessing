import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_provider.dart';
import 'widgets/rating_card.dart';
import 'widgets/wdl_donut.dart';
import 'widgets/achievements_grid.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _editingName = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final profileAsync = ref.watch(profileNotifierProvider);
    final gamesAsync = ref.watch(allGamesProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final games = gamesAsync.value ?? [];

          // Sync controller text when profile loads
          if (!_editingName &&
              _nameController.text != profile.username) {
            _nameController.text = profile.username;
          }

          return CustomScrollView(
            slivers: [
              // ── App bar ──────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                snap: true,
                title: const Text('Profile'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Refresh',
                    onPressed: () =>
                        ref.read(profileNotifierProvider.notifier).refresh(),
                  ),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Avatar + username ──────────────────────────────
                    _AvatarSection(
                      username: profile.username,
                      editingName: _editingName,
                      controller: _nameController,
                      onEditTap: () =>
                          setState(() => _editingName = true),
                      onSave: () {
                        ref
                            .read(profileNotifierProvider.notifier)
                            .updateUsername(_nameController.text);
                        setState(() => _editingName = false);
                      },
                      onCancel: () {
                        _nameController.text = profile.username;
                        setState(() => _editingName = false);
                      },
                    ),
                    const SizedBox(height: 20),

                    // ── Rating card ────────────────────────────────────
                    RatingCard(
                      profile: profile,
                      recentGames: games,
                    ),
                    const SizedBox(height: 20),

                    // ── W/D/L donut ────────────────────────────────────
                    _SectionCard(
                      title: 'Win / Draw / Loss',
                      child: WdlDonut(profile: profile),
                    ),
                    const SizedBox(height: 20),

                    // ── Achievements ───────────────────────────────────
                    _SectionCard(
                      title: 'Achievements',
                      child: AchievementsGrid(
                        profile: profile,
                        games: games,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Avatar + username section ─────────────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  final String username;
  final bool editingName;
  final TextEditingController controller;
  final VoidCallback onEditTap;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _AvatarSection({
    required this.username,
    required this.editingName,
    required this.controller,
    required this.onEditTap,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final initials = username.isNotEmpty
        ? username.trim().split(' ').map((w) => w[0].toUpperCase()).take(2).join()
        : '?';

    return Column(
      children: [
        // Avatar circle
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [cs.primary, cs.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Username / edit field
        if (!editingName) ...[
          GestureDetector(
            onTap: onEditTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  username,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 6),
                Icon(Icons.edit_rounded,
                    size: 16,
                    color: cs.onSurface.withValues(alpha: 0.4)),
              ],
            ),
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                  onSubmitted: (_) => onSave(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.check_rounded, color: cs.primary),
                onPressed: onSave,
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: onCancel,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ── Generic section card ───────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
