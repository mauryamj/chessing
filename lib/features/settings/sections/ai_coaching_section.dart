import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/coaching_service.dart';
import '../settings_provider.dart';

class AiCoachingSection extends ConsumerWidget {
  const AiCoachingSection({super.key});

  String _maskKey(String key) {
    if (key.length <= 8) return '••••••••';
    return '${key.substring(0, 6)}••••••••${key.substring(key.length - 4)}';
  }

  void _showApiKeyDialog(
    BuildContext context,
    WidgetRef ref,
    String currentKey,
  ) {
    final controller = TextEditingController(text: currentKey);
    bool obscureText = true;
    bool isTesting = false;
    String? testResult;
    bool? testSuccess;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final theme = Theme.of(context);
          final cs = theme.colorScheme;

          Future<void> runTest() async {
            final text = controller.text.trim();
            if (text.isEmpty) {
              setState(() {
                testResult = 'Please enter an API key first';
                testSuccess = false;
              });
              return;
            }

            setState(() {
              isTesting = true;
              testResult = null;
              testSuccess = null;
            });

            final ok = await CoachingService.testApiKey(text);

            setState(() {
              isTesting = false;
              testSuccess = ok;
              testResult = ok
                  ? 'Key is valid and active! ✅'
                  : 'Connection failed or invalid key ❌';
            });
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.auto_awesome, color: cs.primary, size: 22),
                const SizedBox(width: 8),
                const Text('Gemini API Key'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your personal Google Gemini API key to enable AI coaching, post-game move reviews, and Grandmaster roleplay advice.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.75),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      hintText: 'AIzaSy...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.key_rounded),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            tooltip: obscureText ? 'Show key' : 'Hide key',
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.paste_rounded),
                            tooltip: 'Paste from clipboard',
                            onPressed: () async {
                              final data =
                                  await Clipboard.getData(Clipboard.kTextPlain);
                              if (data?.text != null) {
                                controller.text = data!.text!.trim();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Test button & status row
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: isTesting ? null : runTest,
                        icon: isTesting
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check_circle_outline, size: 16),
                        label: Text(isTesting ? 'Testing...' : 'Test Key'),
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (testResult != null)
                        Expanded(
                          child: Text(
                            testResult!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: testSuccess == true
                                  ? Colors.green
                                  : cs.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Helper guide text
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: cs.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Get a free Gemini API key at aistudio.google.com with no credit card required.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.8),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              if (currentKey.isNotEmpty)
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(settingsProvider.notifier)
                        .setGeminiApiKey('');
                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gemini API key removed')),
                      );
                    }
                  },
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final newKey = controller.text.trim();
                  await ref
                      .read(settingsProvider.notifier)
                      .setGeminiApiKey(newKey);
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          newKey.isEmpty
                              ? 'Gemini API key cleared'
                              : 'Gemini API key saved successfully!',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (settings) {
        final hasKey = settings.hasCustomGeminiApiKey;

        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: hasKey
                  ? Colors.green.withValues(alpha: 0.12)
                  : cs.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: hasKey ? Colors.green : cs.primary,
              size: 20,
            ),
          ),
          title: const Text(
            'Gemini API Key',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            hasKey
                ? 'Active: ${_maskKey(settings.geminiApiKey)}'
                : 'Not configured • Tap to add key',
            style: TextStyle(
              color: hasKey
                  ? Colors.green
                  : cs.onSurface.withValues(alpha: 0.55),
              fontSize: 12,
            ),
          ),
          trailing: Icon(
            hasKey ? Icons.edit_outlined : Icons.chevron_right_rounded,
            color: cs.onSurface.withValues(alpha: 0.4),
          ),
          onTap: () =>
              _showApiKeyDialog(context, ref, settings.geminiApiKey),
        );
      },
    );
  }
}
