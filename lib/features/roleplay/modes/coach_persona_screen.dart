import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/coaching_service.dart';
import '../../../core/ai/prompts.dart';
import '../../../core/database/app_database.dart';
import '../roleplay_provider.dart';

class CoachPersonaScreen extends ConsumerStatefulWidget {
  const CoachPersonaScreen({super.key});

  @override
  ConsumerState<CoachPersonaScreen> createState() => _CoachPersonaScreenState();
}

class _CoachPersonaScreenState extends ConsumerState<CoachPersonaScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Game> _recentGames = [];
  Game? _selectedRecentGame;

  @override
  void initState() {
    super.initState();
    _loadRecentGames();
    // Scroll to bottom after frame rendering to show existing chat messages
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(animated: false));
  }

  Future<void> _loadRecentGames() async {
    final db = ref.read(databaseProvider);
    final games = await db.getRecentGames(5);
    setState(() {
      _recentGames = games;
    });
  }

  void _onGameSelected(Game? game) {
    if (game == null) return;
    setState(() {
      _selectedRecentGame = game;
    });
    ref.read(coachPersonaChatProvider.notifier).setGameContext(game.pgn, game.result);
    _scrollToBottom();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final chatNotifier = ref.read(coachPersonaChatProvider.notifier);
    final chatState = ref.read(coachPersonaChatProvider);

    _textController.clear();

    // 1. Build conversation history for context before updating state
    final buffer = StringBuffer();
    buffer.writeln(AiPrompts.coachPersonaBaseSystem);
    if (chatState.gameContextPgn.isNotEmpty) {
      buffer.writeln("Here is the context of the game being discussed:\n${chatState.gameContextPgn}\n");
    }
    buffer.writeln("Previous discussion:");
    for (final msg in chatState.messages) {
      buffer.writeln("${msg.role == 'user' ? 'User' : 'Coach'}: ${msg.content}");
    }

    final systemPrompt = buffer.toString();
    final userMessage = text;

    // 2. Add message and set loading
    chatNotifier.addMessage(ChatMessage(role: 'user', content: text, timestamp: DateTime.now()));
    chatNotifier.setLoading(true);
    _scrollToBottom();

    try {
      final coachService = ref.read(coachingServiceProvider);
      final reply = await coachService.ask(systemPrompt, userMessage);
      chatNotifier.addMessage(ChatMessage(role: 'coach', content: reply, timestamp: DateTime.now()));
    } catch (e) {
      chatNotifier.addMessage(ChatMessage(
        role: 'coach',
        content: "Sorry, I lost connection to the server. Please check your internet connection.",
        timestamp: DateTime.now(),
      ));
    } finally {
      chatNotifier.setLoading(false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatState = ref.watch(coachPersonaChatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GM Chess Coach Persona'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'Clear Chat',
            onPressed: () {
              ref.read(coachPersonaChatProvider.notifier).clearChat();
              setState(() {
                _selectedRecentGame = null;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Game Loader Context Bar
            if (_recentGames.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Game>(
                          hint: const Text('Discuss a recent game...', style: TextStyle(fontSize: 13)),
                          isDense: true,
                          value: _selectedRecentGame,
                          items: _recentGames.map((g) {
                            final dateStr = "${g.playedAt.day}/${g.playedAt.month}";
                            return DropdownMenuItem<Game>(
                              value: g,
                              child: Text(
                                '${g.mode.toUpperCase()} game - ${g.result} ($dateStr)',
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: _onGameSelected,
                        ),
                      ),
                    ),
                    if (_selectedRecentGame != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          setState(() {
                            _selectedRecentGame = null;
                          });
                          ref.read(coachPersonaChatProvider.notifier).clearGameContext();
                        },
                      ),
                  ],
                ),
              ),

            // Chat Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatState.messages[index];
                  final isCoach = msg.role == 'coach';

                  return Align(
                    alignment: isCoach ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isCoach
                            ? theme.colorScheme.surfaceContainerHighest
                            : theme.colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isCoach ? 4 : 16),
                          bottomRight: Radius.circular(isCoach ? 16 : 4),
                        ),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCoach ? 'GM Coach' : 'You',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isCoach
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onPrimary.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg.content,
                            style: TextStyle(
                              color: isCoach
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onPrimary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (chatState.isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text('Coach is writing...', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),

            // Input Row
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Ask your coach...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    onPressed: _sendMessage,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
