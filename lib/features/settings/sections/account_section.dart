import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/database/app_database.dart';
import '../../../core/supabase/repositories/profile_repository.dart';
import '../../profile/profile_provider.dart';

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  Future<void> _pickAvatar(BuildContext context, WidgetRef ref, String userId) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 85,
      );
      
      if (image == null) return;
      if (!context.mounted) return;

      final file = File(image.path);
      final repo = ProfileRepository(ref.read(cacheServiceProvider));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploading avatar...')),
      );

      final publicUrl = await repo.uploadAvatar(userId, file);
      
      await repo.updateProfile(avatarUrl: publicUrl);
      ref.invalidate(profileProvider);
      ref.read(profileNotifierProvider.notifier).refresh();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar updated successfully!')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload avatar: $e')),
      );
    }
  }

  void _showEditUsernameDialog(BuildContext context, WidgetRef ref, String currentName, String userId) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter username',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                await ProfileRepository(ref.read(cacheServiceProvider)).updateProfile(username: newName);
                ref.invalidate(profileProvider);
                ref.read(profileNotifierProvider.notifier).updateUsername(newName);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final profileAsync = ref.watch(profileNotifierProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (authState is AuthGuest) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: cs.primary.withValues(alpha: 0.05),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Icon(Icons.account_circle, size: 64, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                'Guest Player',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in with Google to sync stats, save games online, and customize your profile.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).signInWithGoogle();
                },
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (authState is! AuthAuthenticated) {
      return const SizedBox.shrink();
    }

    final user = authState.user;

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();
        
        final username = profile.username;
        final initials = username.isNotEmpty
            ? username.trim().split(' ').map((w) => w[0].toUpperCase()).take(2).join()
            : '?';

        return Column(
          children: [
            // Avatar Picking Row
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: cs.primary.withValues(alpha: 0.1),
                    backgroundImage: profile.avatarPath != null
                        ? CachedNetworkImageProvider(profile.avatarPath!)
                        : null,
                    child: profile.avatarPath == null
                        ? Text(
                            initials,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: cs.primary,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                        onPressed: () => _pickAvatar(context, ref, user.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Username list tile
            ListTile(
              leading: Icon(Icons.person_outline, color: cs.primary),
              title: const Text('Username'),
              subtitle: Text(username),
              trailing: const Icon(Icons.edit, size: 18),
              onTap: () => _showEditUsernameDialog(context, ref, username, user.id),
            ),
            const Divider(indent: 56, height: 1),
            
            // Email display
            ListTile(
              leading: Icon(Icons.email_outlined, color: cs.primary),
              title: const Text('Email'),
              subtitle: Text(user.email ?? 'No email linked'),
            ),
            const Divider(indent: 56, height: 1),

            // Sign out
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Sign Out?'),
                    content: const Text('Are you sure you want to sign out? Your offline games remain local.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sign Out', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ref.read(authNotifierProvider.notifier).signOut();
                }
              },
            ),
            const Divider(indent: 56, height: 1),

            // Delete Account
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Account?', style: TextStyle(color: Colors.red)),
                    content: const Text('WARNING: This will permanently delete your account and remote data. This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ref.read(authNotifierProvider.notifier).deleteAccount();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
