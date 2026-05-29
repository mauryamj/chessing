import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/coaching_service.dart';
import '../../../core/database/app_database.dart';

class ChatMessage {
  final String role; // 'user' or 'coach'
  final String content;
  final DateTime timestamp;

  ChatMessage({required this.role, required this.content, required this.timestamp});
}

class CoachPersonaScreen extends ConsumerStatefulWidget {
  const CoachPersonaScreen({super.key});

  @override
  ConsumerState<CoachPersonaScreen> createState() => _CoachPersonaScreenState();
}

class _CoachPersonaScreenState extends ConsumerState<CoachPersonaScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  List<Game> _recentGames = [];
  Game? _selectedRecentGame;
  String _gameContextPgn = '';

  @override
  void initState() {
    super.initState();
    _loadRecentGames();
    // Welcome message
    _messages.add(
      ChatMessage(
        role: 'coach',
        content: "Hello! I am your Grandmaster Chess Coach. I can help you analyze your games, explain positional concepts, or answer any strategic questions you have. Feel free to load a game PGN from your history so we can review it together!",
        timestamp: DateTime.now(),
      ),
    );
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
      _gameContextPgn = game.pgn;
      _messages.add(
        ChatMessage(
          role: 'coach',
          content: "Excellent! I have loaded that match (Result: ${game.result}). What would you like to know about it? We can review key moments, blunders, or general strategy.",
          timestamp: DateTime.now(),
        ),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(role: 'user', content: text, timestamp: DateTime.now()));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final coachService = ref.read(coachingServiceProvider);
      
      // Build conversation history for context
      final buffer = StringBuffer();
      buffer.writeln("You are a GM chess coach reviewing the user's game. Help them learn and get better.");
      if (_gameContextPgn.isNotEmpty) {
        buffer.writeln("Here is the context of the game being discussed:\n$_gameContextPgn\n");
      }
      buffer.writeln("Previous discussion:");
      for (final msg in _messages.take(_messages.length - 1)) {
        buffer.writeln("${msg.role == 'user' ? 'User' : 'Coach'}: ${msg.content}");
      }

      final systemPrompt = buffer.toString();
      final userMessage = text;

      final reply = await coachService.ask(systemPrompt, userMessage);
      
      setState(() {
        _messages.add(ChatMessage(role: 'coach', content: reply, timestamp: DateTime.now()));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          role: 'coach',
          content: "Sorry, I lost connection to the server. Please check your internet connection.",
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GM Chess Coach Persona'),
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
                            _gameContextPgn = '';
                          });
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
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
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

            if (_isLoading)
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
